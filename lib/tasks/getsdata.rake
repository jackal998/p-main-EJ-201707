namespace :STOCK do

  desc  "go to lookup quote data from stockdog"
  task :get_stock_price do
    stocks_root = "lib/tasks/stocks/"
    #RUBY_PLATFORM => /darwin/ || /win32/

    puts "Executing get_stock_price.rb in " + Dir.pwd + stocks_root
    ruby stocks_root + "get_stock_price.rb", stocks_root
  end
end