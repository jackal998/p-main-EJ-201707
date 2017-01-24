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

  def spgateway_format(data, type, numero, custom_id)
    case type
    when 'shop_info'
      shop_info = [
        "S",                              # 明細錄別
        custom_id,                        # 商店自訂編號
        "B2B",                            # 發票種類
        data[:統一編號],                   # 買受人統一發票
        data[:店家名稱],                   # 買受人名稱
        data[:會計mail],                  # 買受人電子信箱
        data[:公司地址],                   # 買受人地址
        nil ,                             # 載具類別
        nil ,                             # 載具編號
        nil ,                             # 愛心碼
        "Y",                              # 索取紙本發票
        "3",                              # 稅別
        "0",                              # 稅率
        data[:銷售額合計],                  # 銷售額合計
        0,                                # 稅額
        data[:銷售額合計]                   # 發票金額
      ]
    when 'buy_info'
      buy_info = [
        "I",                              # 明細錄別
        custom_id + "-" + numero.to_s,    # 商店自訂編號
        data[:品名],                       # 商品名稱
        data[:數量],                       # 商品數量
        data[:單位],                       # 商品單位
        data[:單價],                       # 商品單價
        data[:免稅總價]                     # 商品小計
      ]
    end
  end

  def check_shop_value(row, table_columns)
    [:店家名稱, :統一編號, :抬頭, :會計mail, :公司地址].each do |column|
      check_val = row[table_columns[column]].value 
      # show_msg('col_empty', [row[table_columns[:店家名稱]].value, column]) if check_val.empty?

      case column
      when :店家名稱    # 買受人名稱
      when :統一編號    # 買受人統一發票
      when :抬頭        # 買受人名稱
      when :會計mail    # 買受人電子信箱
      when :公司地址    # 買受人地址
      end
    end
  end
end