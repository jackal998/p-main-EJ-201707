namespace :STOCK do

  desc  "go to lookup quote data from stockdog"
  task :get_stock_price => :environment do
    require "nokogiri"
    require "watir"
    require "activerecord-import"
    require "activerecord-import/base"
    require "activerecord-import/active_record/adapters/postgresql_adapter"

    require_relative "./stocks/stockdog.rb"

    stocks_root = "lib/tasks/stocks/"
    stockdog_cookies = stocks_root + "stockdog.cookies"

    #Chart Type 技術面當日走勢圖m4p11 (sid & date can also be assigned)
    stockdog_root = "https://www.stockdog.com.tw"
    stockdog_chart_type = stockdog_root + "/stockdog/index.php?m=4&p=11"

    url_params = {}
    #RUBY_PLATFORM => /darwin/ || /win32/

    # Query data with selected condition:
    start_date = Date.parse("2015-01-01")
    end_date = Date.parse("2015-12-31")
    @c = Company.find_by(code: 2330)
    @c_s = @c.stocks

    puts "\n" +
         "------------------------------------\n" +
         "Query data with selected condition:\n" +
         "\n" +
         "Comp. alias: " + @c.alias_name + "\n" +
         "Comp. code : " + @c.code.to_s + "\n" +
         "start_date : " + start_date.strftime("%F") + "\n" +
         "end_date   : " + end_date.strftime("%F") + "\n" +
         "------------------------------------"
    
    # check of data exist
    d = start_date.strftime("%F")
    if @c_s.where("data_datetime >= ?", Time.zone.parse(d)).present?
      puts "Record with queried date " + d + " of Company: " + @c.code.to_s + " already exist, please check.\n" +
           "Last record: " + @c_s.last.data_datetime.strftime("%F") + " \n" +
           " "
      abort("aborted! stocks date exist.")
    end

    puts "Use Browser For Ajax & HTTP Request Handling"
    browser = Watir::Browser.new :chrome
              # , headless: true

    #We have to trigger browser to add cookies
    browser.goto stockdog_root
    browser.cookies.load stockdog_cookies

    browser.goto stockdog_chart_type

    #Get Data url from iframe tag and Gtype into url_params{}
    browser.iframe(:id => "f").wait_until(&:present?)
    browser.cookies.save stockdog_cookies

    #to be tested => FB session time out? and auto renew

    url_params = url_parser(browser.iframe(:id => "f").src)
    url_params[:sid] = @c.code.to_s

    #2013-10-03 date_time validation unique fail
    start_date.upto(end_date) do |qd|

      #Get Data with given condition
      url_params[:date] = qd.strftime("%F")
      data_url = url_params[:noparam] +
        "?date=" + url_params[:date] + 
        "&sid=" + url_params[:sid] + 
        "&Gtype=" + url_params[:Gtype]

      puts "Getting data of " + url_params[:sid] + " on " + url_params[:date]

      browser.goto data_url
      #no data like holiday ...etc
      next if browser.div(:id => "bind_message").present?

      parse_html = Nokogiri::HTML.parse(browser.html, nil, "UTF-8")

      #Get Data From HEAD => <script>
      price_set = data_parser(parse_html.xpath("/html/head/script[6]"))

      price_set.map! { |ps| data_convert(ps) }

      @c_s.import price_set
    end
    puts "last data..." + @c.stocks.last.data_datetime.to_s
  end
end