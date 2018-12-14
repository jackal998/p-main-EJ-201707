require 'nokogiri'
require 'watir'

#Use Browser For Ajax & HTTP Request Handling(HEADER)
browser = Watir::Browser.new :chrome#, headless: true

#Set Target Domain in order to get neet code
domain = 'stockdog.com.tw'

domain_home = 'https://www.' + domain
domain_dot = '.' + domain
domain_www = '.www.' + domain

#We have to trigger browser & domain to add cookies
browser.goto domain_home

browser.cookies.add('STSSESSID', 'qfm7eng1qotp1d4d3vlfspgr75',
  secure: false, path: '/', domain: domain_www)
browser.cookies.add('STSSESSID', 'lrrc4ufnb248hht2gj54nou5m0',
  secure: true,  path: '/', domain: domain_dot)
browser.cookies.add('_ga', 'GA1.3.1578686644.1544281976',
  secure: false, path: '/', domain: domain_dot)
browser.cookies.add('_gid', 'GA1.3.1998926851.1544281976',
  secure: false, path: '/', domain: domain_dot)
browser.cookies.add('G_ENABLED_IDPS', 'google',
  secure: false, path: '/', domain: domain_www)
browser.cookies.add('fbm_268329956608070', 'base_domain=.stockdog.com.tw',
  secure: false, path: '/', domain: domain_dot)
browser.cookies.add('fbm_268329956608070', 'cSu17buNhzBMzfCeMdvUy_0VIMDW9uhbNxNITsVK92M.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImNvZGUiOiJBUUNRVVBXZmtfZ0UxQm40cFZrMmxYOG5Ja2pBcUxLaDdhenhUMkxVb0VYelQ3SmVQOGNnbXlmeFFZTGJEcEtnZG9XSGo0NFgzSTF1M2djUWZUWU1pWjY3YVVCTklLMDF1TVNPUWV2cVpvZlVObWZtaTJ6VjZuekdRZmlqVm12U1FWeVhZTmxnMkdhN21CNkp4Uk1wOWxjaGRZV1Radi1OR3hhRmRUNktsYS03ejYtVkpUa2drTnlBa3lud0ZwbDQ5cWZCMGJjbzVLSlZhaWN6dDF4VjJjVFFHNDVSTXNHUUZrbEt5SE56R2NuLWdTeFU4bV9vTzUyVURKZDZmeFVwUzB4WVYxRUlfZnBnQlMwbFExUUxjUHYwQjlDQVU2Z2NpYzE0aDBIWW9IUkJzODlIUDJxVlJpRTkwdERGcWpGSW5LSlB5b1lFQm5PS0xZeS01TlF5TkgxUSIsImlzc3VlZF9hdCI6MTU0NDQ0NTU0NywidXNlcl9pZCI6IjI0MzU4NzYzNzY0MjkwNTQifQ',
  secure: true,  path: '/', domain: domain_dot)

#Chart Type 技術面當日走勢圖m4p11 (sid & date can also be assigned)
url = domain_home + '/stockdog/index.php?m=4&p=11&sid=2330&date=2013-05-31'

browser.goto url

#Get Data url from iframe tag and Gtype into params{}
browser.iframe(:id => 'f').wait_until(&:present?)

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

