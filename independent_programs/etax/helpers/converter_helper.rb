module ConverterHelper
  def get_open_file_call_back(file_path, parent)
    file_type = File.extname(file_path)
    if file_type == ".xlsx" || file_type == ".xlsm"
      msgBox = show_msg('time_predict', system_performance_test(15,72000))
      file_name = File.basename(file_path, file_type)
  
      target_content = RubyXL::Parser.parse(file_path)

      shops = set_information(target_content)
      write_csv_file(shops, file_name, file_path)
      show_msg('content', '轉換完成！')
    else
      show_msg('filetype_incorrect', file_type)
    end
  end

  private

  def get_table_columns(target_content)
    if target_content['廠商表'].nil? || target_content['銷貨紀錄'].nil?
      show_msg('sheet_missing', 'sheet_missing')
      return nil
    end

    table_title = target_content['銷貨紀錄'][0]
    table_columns = {}
    table_title.cells.each { |cell|
      val = cell && cell.value

      table_columns[:抬頭] = cell.column if val == '抬頭'
      table_columns[:統一編號] = cell.column if val == '統一編號'
      table_columns[:會計mail] = cell.column if val == '會計mail'
      table_columns[:採購mail] = cell.column if val == '採購mail'
      table_columns[:窗口Email] = cell.column if val == '窗口Email'
      table_columns[:負責人mail] = cell.column if val == '負責人mail'
      table_columns[:帳單地址] = cell.column if val == '帳單地址'
      table_columns[:收件地址] = cell.column if val == '收件完整地址'
      table_columns[:公司地址] = cell.column if val == '公司地址'
      table_columns[:品名] = cell.column if val == '品名'
      table_columns[:數量] = cell.column if val == '數量'
      table_columns[:單位] = cell.column if val == '單位'
      table_columns[:單價] = cell.column if val == '單價'
      table_columns[:免稅總價] = cell.column if val == '免稅總價'
      table_columns[:稅率] = cell.column if val == '稅率'
      table_columns[:稅額] = cell.column if val == '稅額'
      table_columns[:含稅總價] = cell.column if val == '含稅總價'
    }

    return table_columns
  end

  def set_information(target_content)
    table_columns = get_table_columns(target_content)

    shops = {}
    target_content['銷貨紀錄'].each { |row| 
      next if row.r == 1
      shop_name = row[table_columns[:抬頭]].value if row
      next if shop_name == '#N/A'
      
      end

      unless exist
        shops[shop_name] = {}
        shops[shop_name][:s_info] = data[:s_info]
        shops[shop_name][:b_info] = []
      end
      shops[shop_name][:s_info][:銷售額合計] += data[:b_info][:免稅總價]
      shops[shop_name][:b_info].push(data[:b_info])
    }
    return shops
  end

  def write_csv_file(shops, file_name, file_path)
    create_date = Date.today.strftime("%Y%m%d")

    our_info = [ 
      "H",                        # 首錄別 
      "INVO",                     # 執行類別
      "C048487545",               # 智付寶企業會員編號
      "315509494",                # 商店代號
      create_date                 # 執行開立日期
    ]

    CSV.open(File.dirname(file_path) + "/" + file_name + ".csv", "wb") do |csv|

      shops.each do |shop|
        custom_id = create_date.to_s + "-" + shop[1][:s_info][:統一編號].to_s

        csv << our_info
        csv << spgateway_format(shop[1][:s_info], 'shop_info', nil, custom_id)

        b_index = 1
        shop[1][:b_info].each do |b_info|
          next if b_info[:單價].class != Fixnum
          csv << spgateway_format(b_info, 'buy_info', b_index, custom_id)
          b_index += 1
        end

      end
    end
  end
end
