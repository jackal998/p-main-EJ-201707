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

      table_columns[:店家編號] = cell.column if val == '店家ID'
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
    log = []
    target_content['銷貨紀錄'].each { |row| 
      next if row.r == 1
      shop_name = row[table_columns[:抬頭]].value if row
      next if shop_name == '#N/A'
      
      exist = shops.include?(shop_name)
      data = check_shop_value(row, table_columns, exist)
      next if data[:s_info].empty? && exist == false

      unless data[:incorrect].nil?
        errors = [row.r]
        data.each do |k,v|
          errors.push(k)
          errors.push(v)
        end
        log.push(errors)
      end

      unless exist
        shops[shop_name] = {}
        shops[shop_name][:s_info] = data[:s_info]
        shops[shop_name][:b_info] = {免稅: {}, 應稅: {}, 其它: {}}
      end

      tax_rate = data[:b_info][:稅率]
      item = data[:b_info][:品名].to_sym

      type = case tax_rate
      when 0
        [:免稅, data[:b_info][:含稅總價]]
      when 0.05
        [:應稅, (data[:b_info][:含稅總價] + data[:b_info][:稅額]).to_i]
      else
        byebug
      end
      p_value = shops[shop_name][:b_info][type[0]][item]
      shops[shop_name][:b_info][type[0]][item] = p_value.nil? ? type[1] : p_value += type[1]
    }
    set_log(log)
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

    CSV.open("315509494_" + create_date + ".csv", "wb") do |csv|
      csv << our_info

      shops.each do |shop|
        custom_id = create_date.to_s + "_" + ("%08d" % shop[1][:s_info][:店家編號])

        shop[1][:b_info].each do |tax_type, b_info|
          next if b_info.empty?
          gui = spgateway_format(shop[1][:s_info], b_info, tax_type, custom_id)

          csv << gui[0]  # GUI title
          gui[1].each do |gui_info|
            csv << gui_info
          end
        end
      end
    end
  end

  def set_log(log)
    CSV.open("315509494_" + Date.today.strftime("%Y%m%d") + "_error_log.csv", "wb") do |csv|
      li = 0
      log.each do |l| 
        csv << l.unshift(li)
        li += 1
      end
    end
  end

end
