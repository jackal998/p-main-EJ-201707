require 'nokogiri'
require 'watir'

#Use Browser For Ajax & HTTP Request Handling(HEADER)
browser = Watir::Browser.new :chrome#, headless: true

stockdog_root_url = 'https://www.stockdog.com.tw'

#We have to trigger browser to add cookies
browser.goto stockdog_root_url
browser.cookies.load ARGV[0] + 'stockdog.cookies'

#Chart Type 技術面當日走勢圖m4p11 (sid & date can also be assigned)
url = stockdog_root_url + '/stockdog/index.php?m=4&p=11'
browser.goto url

#Get Data url from iframe tag and Gtype into params{}
browser.iframe(:id => 'f').wait_until(&:present?)
browser.cookies.save ARGV[0] + 'stockdog.cookies'

#case handle => FB session time out?

price_url = browser.iframe(:id => 'f').src

params = {}
price_url.split('?')[1].split('&').each do |par|
  params[par.split('=')[0].to_sym] = par.split('=')[1]
end

#Get Data with given condition
data_url = price_url.split('?')[0] +
  '?date=' + params[:date] + 
  '&sid=' + params[:sid] + 
  '&Gtype=' + params[:Gtype]

browser.goto data_url

#Get Data From HEAD => <script>
parse_html = Nokogiri::HTML.parse(browser.html, nil, 'UTF-8')
price_html = parse_html.xpath("/html/head/script[6]")
price_preset = price_html.to_s.match(/var\s+data\s+=\s\[\[(.*?)\]\]\s+var/)[1]
price_set = price_preset.split('],[')

print(price_set.class)
print(price_set.length)
print(price_set[0])
print(price_set[99])

#ajax_day('2013-05-1' + number);$('#id_date').val('2013-05-1' + number);

