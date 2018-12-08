require 'open-uri'
require 'nokogiri'

url = 'https://www.stockdog.com.tw/stockdog/ajax.php?sid=2330&date=2013-05-21&Atype=6ad42af7bfb03cda85bea8a7d2f25dee6d'
html = open(url)
parse_html = Nokogiri::HTML.parse(html)
price_set = parse_html.xpath("//div[contains(@id,'container')]")

#$x("//div[contains(@id,'highcharts-0')]")

print(price_set)
