namespace :dev do

  desc "Rebuild system"
  task :rebuild => ["db:drop", "db:setup", :fake]

  task :fake => :environment do
    puts "Create fake data for development"
    100.times do

      User.all.sample.stocks.create(
        :datatime => Faker::Time.backward(14, :all), 
        :value => Faker::Number.decimal(3, 3))
    end

    puts "Create finished"
  end
end