class ServicesController < ApplicationController
  before_action :set_current_user
  before_action :authenticate_user!

  def index

  end

  def tension
    
  end

  def testview
    
  end

  ### incorrect URL handler
  def www
    redirect_to path_without_www, status: 301
  end
  def noroutes
    redirect_to root_path
  end
  ###

  private

  def set_current_user
    @user = get_user_if_cookies cookies[:show_me_who_your_are]
    new_cookie = set_new_cookies(:show_me_who_your_are, request.remote_ip)

    if @user
      @user.update_attribute(:cookie_show_me_who_your_are, new_cookie)
    else
      @user = User.new(
        :nickname => "guest", 
        :email => "guest_#{Time.now.to_i}#{rand(99)}@guest.tw",  # .tw 可以加入國籍辨別
        :role => "guest",
        :cookie_show_me_who_your_are => new_cookie
      )
      @user.save(:validate => false)
    end
    sign_in(@user)
  end

  def get_user_if_cookies(cookie)
    User.find_by_cookie_show_me_who_your_are(cookie) if cookie
  end

  def set_new_cookies(cookie, data)
    cookies[cookie] = {
      :value => new_SHA2(data),
      :expires => 1.month.from_now,
    }
    cookies[cookie]
  end

  def new_SHA2(ref)
    require 'digest'
    ref = ref.to_s
    Digest::SHA2.hexdigest ref + Time.now.to_s
  end

  def path_without_www
    domain = dev? ? 'http://localhost:3000' : 'https://' + Rails.application.config_for(:domain)
    domain + request.path
  end
  def dev?
    Rails.env == 'development'
  end
end
