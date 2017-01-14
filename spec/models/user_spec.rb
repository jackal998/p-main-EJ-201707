require 'rails_helper'

RSpec.describe User, type: :model do

  describe "model" do
    describe "check registerable" do
      context "while creating a new user" do

        it "then check if is employee" do
          u_corrrect = User.new(
            :email => "qazwsxedcrfvtgbyhnujmikolp@ilovemilk.com.tw", 
            :password => "12345678", 
            :password_confirmation => "12345678" )

          expect(u_corrrect.save).to eq(true)
        end

        it "then check if wrong employee name" do
          u_incorrrect_name = User.new(
            :email => "im_not@ilovemilk.com.tw", 
            :password => "12345678", 
            :password_confirmation => "12345678" )

          expect(u_incorrrect_name.save).to eq(false)
        end

        it "then check if wrong email address" do
          u_incorrrect_address = User.new(
            :email => "qazwsxedcrfvtgbyhnujmikolp@gmail.com", 
            :password => "12345678", 
            :password_confirmation => "12345678" )

          expect(u_incorrrect_address.save).to eq(false)
        end
      end
    end
  end
end