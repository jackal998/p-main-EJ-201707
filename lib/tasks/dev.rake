namespace :dev do

  desc "Rebuild system"
  task :rebuild => ["db:drop", "db:setup", :fake]

  task :fake => :environment do
    puts "Create fake data for development"

    15.times do
      puts "Create fake Company and Stock prices"
      com = Company.new(
        :full_name => Faker::Company.name, 
        :code => Faker::Number.leading_zero_number(4),)
      com.save!
      20.times do
        st = Stock.new(
          :company_id => com.id,
          :data_datetime => Faker::Time.backward(3, :all),
          :price => Faker::Number.decimal(3, 2))
        st.save!
      end
    end
    puts "dev:fake Create Finished"
  end
end