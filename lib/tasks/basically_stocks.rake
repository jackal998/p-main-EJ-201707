namespace :STOCK do

  desc  "go to lookup quote data from stockdog"
  task :get_stock_price => :environment do
    require "nokogiri"
    require "watir"
    require "activerecord-import"
    require "activerecord-import/base"
    require "activerecord-import/active_record/adapters/postgresql_adapter"

    require_relative "./stocks/stockdog_helper.rb"

    stocks_root = "lib/tasks/stocks/"
    stockdog_cookies = stocks_root + "stockdog.cookies"

    #Chart Type 技術面當日走勢圖m4p11 (sid & date can also be assigned)
    stockdog_root = "https://www.stockdog.com.tw"
    stockdog_chart_type = stockdog_root + "/stockdog/index.php?m=4&p=11"

    url_params = {}
    #RUBY_PLATFORM => /darwin/ || /win32/

    # Query data with selected condition:
    start_date = Date.parse("2013-05-09")
    end_date = Date.today

    puts "Use Browser For Ajax & HTTP Request Handling"
    browser = Watir::Browser.new :chrome
              # , headless: true

    Company.all.each do |comp|
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

  desc "export data with selected condition"
  task :export, [:company_code, :start_date, :end_date]  => :environment  do |t, args|
    require 'csv'
    require_relative "./stocks/export_helper.rb"
    args.with_defaults(company_code: "empty", start_date: "empty", end_date: "empty")
    args = args_check(args)

    abort "ArgumentError: invalid company_code" unless args[:company_code]
    puts "Exporting Company data from code #{args[:company_code]}..."
    
    comp = Company.find_by(code: args[:company_code])
    abort "Company => code: #{args[:company_code]} is not found" unless comp.present?
    
    # Testing data Split by month
    start_date = args[:start_date]
    end_date = args[:end_date]
    puts "\n" +
         "---------------------------------------\n" +
         "Exporting data with selected condition:\n" +
         "\n" +
         "Comp. alias: " + comp.alias_name + "\n" +
         "Comp. code : " + comp.code.to_s + "\n" +
         "start_date : " + start_date.strftime("%F") + "\n" +
         "end_date   : " + end_date.strftime("%F") + "\n" +
         "---------------------------------------"

    directory = "#{Rails.root}/public/#{comp.code}"
    Dir.mkdir(directory) unless File.exists?(directory)
    
    file = directory + "/#{start_date.strftime("%Y%m%d") + end_date.strftime("%Y%m%d")}_#{Time.now.strftime("%m%d%H%M%S")}.csv"

    column_headers = %w(id data_datetime price volume)
    CSV.open(file, 'w', write_headers: true) do |csv|
      csv << column_headers.map(&:humanize)
      comp.stocks.where(:data_datetime => start_date..end_date ).order('stocks.data_datetime ASC').find_in_batches do |stocks|
        stocks.each do |s|
          csv << s.attributes.values_at(*column_headers)
        end
      end
    end
  end

  desc "export check file with selected condition"
  task :chk_file, [:company_code, :start_date, :end_date]  => :environment  do |t, args|
    require 'csv'
    require_relative "./stocks/export_helper.rb"
    args.with_defaults(company_code: "empty", start_date: "empty", end_date: "empty")
    args = args_check(args)

    abort "ArgumentError: invalid company_code" unless args[:company_code]
    puts "Exporting Company data from code #{args[:company_code]}..."

    comp = Company.find_by(code: args[:company_code])
    abort "Company => code: #{args[:company_code]} is not found" unless comp.present?
    
    Company.all.each do |comp|

      # Testing data Split by month
      start_date = args[:start_date]
      end_date = args[:end_date]
      puts "\n" +
           "-------------------------------------------\n" +
           "Exporting chk file with selected condition:\n" +
           "\n" +
           "Comp. alias: " + comp.alias_name + "\n" +
           "Comp. code : " + comp.code.to_s + "\n" +
           "start_date : " + start_date.strftime("%F") + "\n" +
           "end_date   : " + end_date.strftime("%F") + "\n" +
           "-------------------------------------------"

      directory = "#{Rails.root}/public/#{comp.code}_chk"
      Dir.mkdir(directory) unless File.exists?(directory)
      
      file = directory + "/#{start_date.strftime("%Y%m%d") + end_date.strftime("%Y%m%d")}_#{Time.now.strftime("%m%d%H%M%S")}.csv"

      column_headers = %w(date min max range count)
      CSV.open(file, 'w', write_headers: true) do |csv|
        csv << column_headers.map(&:humanize)
        comp.stocks.where(:data_datetime => start_date..end_date).group_by_day(:data_datetime).calculate_all(:count, D_Min: 'MIN(data_datetime)', D_Max: 'MAX(data_datetime)', D_Rng: 'MAX(data_datetime) - MIN(data_datetime)').map do |k,v|
          csv << v.map { |k2, v2| v2 }.unshift(k)
        end
      end
    end
  end
end