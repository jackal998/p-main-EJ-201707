require 'nokogiri'
require 'watir'

browser = Watir::Browser.new :chrome, headless: true

url = 'https://www.stockdog.com.tw'

browser.goto url
browser.cookies.add( 
  'STSSESSID', 
  'qfm7eng1qotp1d4d3vlfspgr75',
  secure: false,
  path: '/',
  domain: '.www.stockdog.com.tw')
browser.cookies.add( 
  '_ga', 
  'GA1.3.1578686644.1544281976',
  secure: false,
  path: '/',
  domain: '.stockdog.com.tw')

browser.cookies.add(
  '_gid', 
  'GA1.3.1998926851.1544281976',
  secure: false,
  path: '/',
  domain: '.stockdog.com.tw')

browser.cookies.add(
  'G_ENABLED_IDPS', 
  'google',
  secure: false,
  path: '/',
  domain: '.www.stockdog.com.tw')

browser.cookies.add( 
  'fbm_268329956608070', 
  'base_domain=.stockdog.com.tw',
  secure: false,
  path: '/',
  domain: '.stockdog.com.tw')

browser.cookies.add( 
  'STSSESSID', 
  'lrrc4ufnb248hht2gj54nou5m0',
  secure: true,
  path: '/',
  domain: '.stockdog.com.tw')

browser.cookies.add( 
  'fbm_268329956608070', 
  'cSu17buNhzBMzfCeMdvUy_0VIMDW9uhbNxNITsVK92M.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImNvZGUiOiJBUUNRVVBXZmtfZ0UxQm40cFZrMmxYOG5Ja2pBcUxLaDdhenhUMkxVb0VYelQ3SmVQOGNnbXlmeFFZTGJEcEtnZG9XSGo0NFgzSTF1M2djUWZUWU1pWjY3YVVCTklLMDF1TVNPUWV2cVpvZlVObWZtaTJ6VjZuekdRZmlqVm12U1FWeVhZTmxnMkdhN21CNkp4Uk1wOWxjaGRZV1Radi1OR3hhRmRUNktsYS03ejYtVkpUa2drTnlBa3lud0ZwbDQ5cWZCMGJjbzVLSlZhaWN6dDF4VjJjVFFHNDVSTXNHUUZrbEt5SE56R2NuLWdTeFU4bV9vTzUyVURKZDZmeFVwUzB4WVYxRUlfZnBnQlMwbFExUUxjUHYwQjlDQVU2Z2NpYzE0aDBIWW9IUkJzODlIUDJxVlJpRTkwdERGcWpGSW5LSlB5b1lFQm5PS0xZeS01TlF5TkgxUSIsImlzc3VlZF9hdCI6MTU0NDQ0NTU0NywidXNlcl9pZCI6IjI0MzU4NzYzNzY0MjkwNTQifQ',
  secure: true,
  path: '/',
  domain: '.stockdog.com.tw')

url = 'https://www.stockdog.com.tw/stockdog/graph.php?date=2013-05-31&sid=2330&Gtype=834aa8fbcd505d0a113ff8f7d76cbe0eaf'
browser.goto url

parse_html = Nokogiri::HTML.parse(browser.html, nil, 'UTF-8')
price_html = parse_html.xpath("/html/head/script[6]")
price_preset = price_html.to_s.match(/var\s+data\s+=\s\[\[(.*?)\]\]\s+var/)[1]
price_set = price_preset.split('],[')
print(price_set.class)
print(price_set.length)
print(price_set[0])
print(price_set[99])

#ajax_day('2013-05-1' + number);$('#id_date').val('2013-05-1' + number);

