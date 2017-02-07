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

  def spgateway_format(data, type, custom_id)
    case type

    when 'shop_info'
      shop_info = [
        "S",                              # 明細錄別
        custom_id,                        # 商店自訂編號
        data[:發票種類],                    # 發票種類
        data[:買受人統一發票],               # 買受人統一發票
        data[:買受人名稱],                  # 買受人名稱
        data[:買受人電子信箱],               # 買受人電子信箱
        data[:買受人地址],                  # 買受人地址 (非必填)
        nil ,                             # 載具類別
        nil ,                             # 載具編號
        nil ,                             # 愛心碼
        "Y",                              # 索取紙本發票
        data[:稅別],                       # 稅別
        data[:稅率],                       # 稅率
        data[:銷售額合計],                  # 銷售額合計
        data[:稅額],                       # 稅額
        data[:發票金額]                     # 發票金額
      ]
    when 'buy_info'
      buy_info = [
        "I",                              # 明細錄別
        custom_id,                        # 商店自訂編號
        data[:品名],                       # 商品名稱
        data[:數量],                       # 商品數量
        data[:單位],                       # 商品單位
        data[:單價],                       # 商品單價
        data[:免稅總價]                     # 商品小計
      ]
    end
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
          發票種類: b_type,
          買受人名稱: row[table_columns[:抬頭]].value,
          買受人統一發票: row[table_columns[:統一編號]].value.to_i,
          買受人電子信箱: company_email,
          買受人地址: row[table_columns[:帳單地址]].value,
          銷售額合計: 0
        }
      end
    end

    [:品名, :數量, :單位].each do |column|
      data[:b_info][column] = row[table_columns[column]].value
    end

    [:單價, :免稅總價, :稅率, :稅額, :含稅總價].each do |column|
      val = row[table_columns[column]].value
      incorrect[column] = 'type' unless val.class == Fixnum || val.class == Float
      data[:b_info][column] = val.to_f
    end
    
    data[:incorrect] = incorrect if incorrect.any?

    return data
  end

end