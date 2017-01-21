require 'tk'
require 'rubyXL'
require 'csv'
require 'byebug'

def init_root_window
    
  def set_open_button(root, btn_method, label)
    button = TkButton.new(root) do
      text label
      pack("side" => "left",  "padx"=> "55", "pady"=> "5")
    end
    button.comman = btn_method
  end

  def get_open_file_call_back(file_path)

    file_type = File.extname(file_path)
    if file_type == ".xlsx" || file_type == ".xlsm"
      file_name = File.basename(file_path, file_type)
      show_msg('time_predict', system_performance_test)

      target_content = RubyXL::Parser.parse(file_path)

      set_information(target_content, file_name, file_path)
    else
      show_msg('filetype_incorrect', file_type)
    end
  end

  def set_information(target_content, file_name, file_path)
    table_columns = get_table_columns(target_content)

    shops = {}
    target_content['銷貨紀錄'].each { |row| 
      next if row.r == 1
      shop_name = row[table_columns[:店家名稱]].value if row
      next if shop_name == '#N/A'

      unless shops.include?(shop_name)
        shops[shop_name] = {
          s_info: {
            店家名稱: row[table_columns[:店家名稱]].value,
            統一編號: row[table_columns[:統一編號]].value,
            抬頭: row[table_columns[:抬頭]].value,
            會計mail: row[table_columns[:會計mail]].value,
            公司地址: row[table_columns[:公司地址]].value 
          }
        }
        shops[shop_name][:b_info] = []
      end

      b_info = {
        品名: row[table_columns[:品名]].value,
        數量: row[table_columns[:數量]].value,
        單位: row[table_columns[:單位]].value,
        單價: row[table_columns[:單價]].value,
        免稅總價: row[table_columns[:免稅總價]].value,
        含稅總價: row[table_columns[:含稅總價]].value
      }
      shops[shop_name][:b_info].push(b_info)
    }

    create_date = Date.today.strftime("%Y%m%d")
    CSV.open(File.dirname(file_path) + "/" + file_name + ".csv", "wb") do |csv|

      shops.each do |shop|
        b_index = 1
        custom_id = create_date.to_s + "-" + shop[1][:s_info][:統一編號].to_s

        #        首錄別 執行類別 智付寶企業會員編號 商店代號   執行開立日期            
        csv << [ "H", "INVO", "C048487545", "315509494", create_date]

        #   明細錄別  商店自訂編號 發票種類     買受人統一發票                 買受人名稱             買受人電子信箱                 買受人地址 載具類別  載具編號  愛心碼 索取紙本發票  稅別  稅率  # 銷售額合計 稅額  發票金額
        csv << ["S", custom_id, "B2B", shop[1][:s_info][:統一編號], shop[1][:s_info][:店家名稱], shop[1][:s_info][:會計mail], shop[1][:s_info][:公司地址], nil , nil , nil ,"Y","3","0" ]
        
        shop[1][:b_info].each do |b_info|
          next if b_info[:單價].class != Fixnum
          # 明細錄別  商店自訂編號  商品名稱  商品數量  商品單位  商品單價  商品小計
          csv << ["I", custom_id + "-" + b_index.to_s, b_info[:品名], b_info[:數量], b_info[:單位], b_info[:單價], b_info[:免稅總價]]

          b_index += 1
        end
        
      end
    end         
    byebug
  end

  def get_table_columns(target_content)
    if target_content['廠商表'].nil? || target_content['銷貨紀錄'].nil?
      show_msg('sheet_missing', 'sheet_missing')
      return nil
    end

    table_title = target_content['銷貨紀錄'][0]
    table_columns = {}
    table_title.cells.each { |cell|
      val = cell && cell.value
      table_columns[:店家名稱] = cell.column if val == '店家名稱'
      table_columns[:統一編號] = cell.column if val == '統一編號'
      table_columns[:抬頭] = cell.column if val == '抬頭'
      table_columns[:會計mail] = cell.column if val == '會計mail'
      table_columns[:公司地址] = cell.column if val == '公司地址'
      table_columns[:品名] = cell.column if val == '品名'
      table_columns[:數量] = cell.column if val == '數量'
      table_columns[:單位] = cell.column if val == '單位'
      table_columns[:單價] = cell.column if val == '單價'
      table_columns[:免稅總價] = cell.column if val == '免稅總價'
      table_columns[:含稅總價] = cell.column if val == '含稅總價'
    }
    return table_columns
  end

  def system_performance_test
    spt = []
    10.times {spt.push(duration_test)}
    ((spt.inject{ |sum, el| sum + el }.to_f / spt.size) * 44530 ).round(0)
  end

  def duration_test
    st = Time.now
    a=0
    1..5000.times { |variable| a += variable }
    fh = Time.now
    time = fh - st
  end

  def show_msg(type, content)
    case type
    when 'filetype_incorrect'
      if content.empty?
        msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "沒有選擇檔案",
        'message' => "沒有選擇檔案"
        )
      else
        msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "格式錯誤",
        'message' => "格式#{content}不是可以轉換的格式"
        )
      end
    when 'sheet_missing'
      msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "資料錯誤",
        'message' => "廠商表、銷貨紀錄遺失或是名稱錯誤"
        )
    when 'time_predict'
      msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "要花點時間喔！",
        'message' => "資料載入中，需時約#{content}秒"
        )
    end
  end

  root = TkRoot.new do
    title "鮮乳坊小工具"
  end

  button_click = Proc.new { get_open_file_call_back(Tk.getOpenFile) }

  set_open_button(root, button_click, "開啟檔案")

  Tk.mainloop
end

init_root_window

byebug
# target = RubyXL::Workbook.new

# workbook.write("path/to/desired/Excel/file.xlsx")