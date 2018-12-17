namespace :STOCK do

  desc  "go to lookup quote data from stockdog"
  task :get_stock_price => :environment do
    require 'nokogiri'
    require 'watir'
    require_relative './stocks/stockdog.rb'

    stocks_root = "lib/tasks/stocks/"
    stockdog_cookies = stocks_root + 'stockdog.cookies'

    #Chart Type 技術面當日走勢圖m4p11 (sid & date can also be assigned)
    stockdog_root = 'https://www.stockdog.com.tw'
    stockdog_chart_type = stockdog_root + '/stockdog/index.php?m=4&p=11'

    url_params = {}
    #RUBY_PLATFORM => /darwin/ || /win32/

    puts 'Use Browser For Ajax & HTTP Request Handling'
    browser = Watir::Browser.new :chrome#, headless: true

    #We have to trigger browser to add cookies
    browser.goto stockdog_root
    browser.cookies.load stockdog_cookies

    browser.goto stockdog_chart_type

    #Get Data url from iframe tag and Gtype into url_params{}
    browser.iframe(:id => 'f').wait_until(&:present?)
    browser.cookies.save stockdog_cookies

    #to be tested => FB session time out? and auto renew

    url_params = url_parser(browser.iframe(:id => 'f').src)

    #Start Query with selected condition
    Date.parse('2013-05-09').upto(Date.parse('2013-05-19')) do |date|
      url_params[:date] = date.to_s

      #Get Data with given condition
      data_url = url_params[:noparam] +
        '?date=' + url_params[:date] + 
        '&sid=' + url_params[:sid] + 
        '&Gtype=' + url_params[:Gtype]

      puts 'Getting data of ' + url_params[:sid] + ' on ' + url_params[:date]

      browser.goto data_url
      next if browser.div(:id => 'bind_message').present?

      parse_html = Nokogiri::HTML.parse(browser.html, nil, 'UTF-8')

      #Get Data From HEAD => <script>
      price_set = parse_html.xpath("/html/head/script[6]").to_s.match(/var\s+data\s+=\s\[\[(.*?)\]\]\s+var/)[1].split('],[')

      print(price_set[0])
    end
  end
end