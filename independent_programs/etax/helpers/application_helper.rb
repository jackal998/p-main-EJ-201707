module ApplicationHelper
  def system_performance_test(times, magnification)
    spt = []
    times.times {spt.push(duration_test)}
    ((spt.inject{ |sum, el| sum + el }.to_f / spt.size) * magnification).round(0)
  end

  def duration_test
    st = Time.now
    a=0
    1..5000.times { |variable| a += variable }
    fh = Time.now
    time = fh - st
  end

  def spgateway_format(s_info, b_info, t_type, custom_id)
    
    buy_info = []
    sum = 0
    t_table = {應稅: 1, 其它: 2, 免稅: 3}
    custom_id += "_" + t_table[t_type].to_s

    b_info.each do |p_name, total|
      total_to_i = total.to_i
      buy_info.push([
          "I",                                      # 明細錄別
          custom_id,                                # 商店自訂編號
          p_name.to_s,                              # 商品名稱
          1,                                        # 商品數量
          '件',                                     # 商品單位
          total_to_i,                               # 商品單價
          total_to_i                                # 商品小計
        ])
      sum += total_to_i
    end

    spgateway_format_type = case t_type
    when :應稅
      [t_table[t_type],5,(sum/1.05).round(0),(sum*0.05/1.05).round(0),sum]
    when :其它
      [t_table[t_type],0,0,0,0]
    when :免稅
      [t_table[t_type],0,sum,0,sum]
    else
      byebug
    end

    shop_info = [
      "S",                                # 明細錄別
      custom_id,                          # 商店自訂編號
      s_info[:發票種類],                   # 發票種類
      s_info[:買受人統一發票],              # 買受人統一發票
      s_info[:買受人名稱],                 # 買受人名稱
      s_info[:買受人電子信箱],              # 買受人電子信箱
      s_info[:買受人地址],                 # 買受人地址 (非必填)
      nil ,                               # 載具類別
      nil ,                               # 載具編號
      nil ,                               # 愛心碼
      "Y",                                # 索取紙本發票
      spgateway_format_type[0],           # 稅別
      spgateway_format_type[1],           # 稅率
      spgateway_format_type[2],           # 銷售額合計
      spgateway_format_type[3],           # 稅額
      spgateway_format_type[4]            # 發票金額
    ]

    return [shop_info, buy_info]
  end

  def check_shop_value(row, table_columns, exist)
    
    data = {}
    data[:s_info] = {}
    data[:b_info] = {}

    incorrect = {}
    unless exist
      company_tax_ID = row[table_columns[:統一編號]].value
      if company_tax_ID == '二聯發票'
        b_type = 'B2C'
      elsif company_tax_ID.to_s.length == 8
        b_type = 'B2B'
        incorrect[:買受人名稱] = 'nil' if row[table_columns[:抬頭]].value.nil?
      else
        b_type = nil
        incorrect[:買受人統一發票] = 'format' 
      end

      company_email = row[table_columns[:會計mail]].value
      if company_email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      elsif company_email.nil?
        incorrect[:買受人電子信箱] = 'nil' 
      else
        incorrect[:買受人電子信箱] = 'format'
      end

      if b_type
        data[:s_info] = {
          店家編號: row[table_columns[:店家編號]].value.to_s,
          發票種類: b_type,
          買受人名稱: row[table_columns[:抬頭]].value,
          買受人統一發票: row[table_columns[:統一編號]].value.to_s,
          買受人電子信箱: company_email,
          買受人地址: row[table_columns[:帳單地址]].value,
        }
      end
    end

    [:品名, :單位].each do |column|
      data[:b_info][column] = row[table_columns[column]].value
    end

    [:單價, :數量, :免稅總價, :稅率, :稅額, :含稅總價].each do |column|
      val = row[table_columns[column]].value
      incorrect[column] = 'type' unless val.class == Fixnum || val.class == Float
      data[:b_info][column] = val.to_f
    end
    
    data[:incorrect] = incorrect if incorrect.any?

    return data
  end

end