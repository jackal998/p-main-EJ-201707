namespace :STOCK do

  desc  "go to lookup quote data from stockdog"
  task :get_stock_price do
  # the ruby file's path is in the project root, the file should be placed in there
  ruby "get_stock_price.rb"
  end

end