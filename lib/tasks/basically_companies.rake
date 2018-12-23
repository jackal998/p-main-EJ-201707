namespace :COMPANY do

  desc  "go to lookup comp. info from https://www.cnyes.com/twstock/intro/"
  task :get_comp_info => :environment do
    # require "nokogiri"
    # require "watir"

    # path_root = "https://www.cnyes.com/twstock/intro/"
    # browser = Watir::Browser.new :chrome
    #           # , headless: true
    # [3045].each do |code|
    #   browser.goto path_root + code.to_s + ".htm"

    #   parse_html = Nokogiri::HTML.parse(browser.html, nil, "UTF-8")
    #   browser.span(:id => "ctl00_ContentPlaceHolder1_Label030").wait_until(&:present?)
    #   alias_name = parse_html.xpath("//*[@id='ctl00_ContentPlaceHolder1_Label031']")[0].inner_text
    #   full_name = parse_html.xpath("//*[@id='ctl00_ContentPlaceHolder1_Label030']")[0].inner_text
      
    #   Company.create(code: code, alias_name: alias_name, full_name: full_name)
    # end
  end

  desc  "go to lookup comp. info from https://goodinfo.tw/StockInfo/BasicInfo.asp?STOCK_ID="
  task :update_comp_info => :environment do
    # require "nokogiri"
    # require "watir"

    # path_root = "https://goodinfo.tw/StockInfo/BasicInfo.asp?STOCK_ID="

    # browser = Watir::Browser.new :chrome
    #           # , headless: true

    # Company.where('id <= 3').map do |c|
    # # Company.all.map do |c|
    #   code = c.code.to_s
    #   browser.goto path_root + code
    #   sleep(3.27)
    #   parse_html = Nokogiri::HTML.parse(browser.html, nil, "UTF-8")
    #   browser.table(:class => "solid_1_padding_2_6_tbl").wait_until(&:present?)
    #   full_name = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[4]/td[2]")[0].inner_text
    #   description = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[22]/td[2]/p")[0].inner_text
    #   chairman = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[12]/td[2]")[0].inner_text
    #   president = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[13]/td[2]")[0].inner_text
    #   establishment = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[6]/td[2]/nobr")[0].inner_text.to_s.match(/(.{10})/)[1]
    #   listed_date = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[7]/td[2]/nobr")[0].inner_text.to_s.match(/(.{10})/)[1]
    #   tax_ID = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[17]/td[2]")[0].inner_text
    #   cat = parse_html.xpath("/html/body/table[2]/tbody/tr/td[3]/table[2]/tbody/tr[3]/td[2]")[0].inner_text

    #   c.update(
    #     full_name: full_name,
    #     description: description,
    #     chairman: chairman,
    #     president: president,
    #     tax_ID: tax_ID,
    #     establishment: establishment.to_date,
    #     listed_date: listed_date.to_date,
    #     category: Category.find_by(name: cat.to_s)
    #     )
    # end
  end
end