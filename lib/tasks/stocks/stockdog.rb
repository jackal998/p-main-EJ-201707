def url_parser(url)
  temp = {}
  puts 'Parsing url...'

  temp = {full: url,
          noparam: url.split('?')[0]}

  url.split('?')[1].split('&').each do |par|
    temp[par.split('=')[0].to_sym] = par.split('=')[1]
  end

  return temp
end