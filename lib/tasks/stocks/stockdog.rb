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

def data_parser(raw)
  raw.to_s.match(/var\s+data\s+=\s\[\[(.*?)\]\]\s+var/)[1].split('],[')
end

def data_convert(raw)
  temp = {}
  dt_temp = raw.to_s.match(/\((.*)\)/)[1].split(',').map! { |e| e.to_i }
  price_temp = raw.to_s.match(/\)\,(.*)/)[1].split(',')
  
  #months from js UTC are from 0-11  
  temp = {data_datetime: DateTime.new(dt_temp[0],dt_temp[1] + 1,dt_temp[2],dt_temp[3],dt_temp[4],dt_temp[5],Rational(8,24)),
          price: price_temp[0],
          volume: price_temp[1]}
end