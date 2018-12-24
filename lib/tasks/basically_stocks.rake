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
    start_date = Date.parse("2013-05-09")
    end_date = Date.parse("2018-12-21")

    puts "Use Browser For Ajax & HTTP Request Handling"
    browser = Watir::Browser.new :chrome
              # , headless: true

    # fail: 46,35,47,48 
    [46,35,47,48,81,84,86,89,92,96,97,100,102,13,15,18,19,22,24,49,52,54,56,57,58,61,63,65,66,67,70,72,73,75,76,78,79,80,82,83,85,87,88,90,91,93,94,95,98,99,101,10,16].each do |id|
      comp = Company.find(id)
      # @c = Company.find_by(code: 2317)
      c_s_last = comp.stocks.maximum("data_datetime")
      start_date = (c_s_last + 1.day).to_date if c_s_last.present?

      puts "\n" +
           "------------------------------------\n" +
           "Query data with selected condition:\n" +
           "\n" +
           "Comp. alias: " + comp.alias_name + "\n" +
           "Comp. code : " + comp.code.to_s + "\n" +
           "start_date : " + start_date.strftime("%F") + "\n" +
           "end_date   : " + end_date.strftime("%F") + "\n" +
           "------------------------------------"

      #We have to trigger browser to add cookies
      browser.goto stockdog_root
      browser.cookies.load stockdog_cookies

      browser.goto stockdog_chart_type

      #Get Data url from iframe tag and Gtype into url_params{}
      browser.iframe(:id => "f").wait_until(&:present?)
      browser.cookies.save stockdog_cookies

      url_params = url_parser(browser.iframe(:id => "f").src)
      url_params[:sid] = comp.code.to_s

      #2013-10-03 date_time validation unique fail
      start_date.upto(end_date) do |qd|

        #Get Data with given condition
        url_params[:date] = qd.strftime("%F")
        data_url = url_params[:noparam] +
          "?date=" + url_params[:date] + 
          "&sid=" + url_params[:sid] + 
          "&Gtype=" + url_params[:Gtype]

        print "Getting data of " + url_params[:sid] + " on " + url_params[:date] + "..."

        browser.goto data_url
        #no data like holiday ...etc
        next if browser.div(:id => "bind_message").present?

        parse_html = Nokogiri::HTML.parse(browser.html, nil, "UTF-8")

        #Get Data From HEAD => <script>
        pre_price_set = data_parser(parse_html.xpath("/html/head/script[6]"))

        pre_price_set.map! { |ps| data_convert(ps) }
        price_set = pre_price_set.compact

        comp.stocks.import price_set
        puts "Success"
      end
    end
  end
end