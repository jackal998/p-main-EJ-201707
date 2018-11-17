class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  
  validate :employee
  serialize :fb_raw_data
  
  def self.from_omniauth(auth, cookie)

    # user_by_cookies = User.find_by_show_me_who_u_r(cookie)
    user_by_email = User.find_by_email( auth.info.email )
    user_by_provider = User.where(provider: auth.provider, provider_uid: auth.uid).first

    if user_by_provider || user_by_email
      u = user_by_provider || user_by_email
      # Case 1: provider user existed, update informations from provider and user_by_cookies
      u.nickname = auth.info.name if u.nickname = 'guest'
      u.provider = auth.provider
      u.provider_avatar = auth.info.image
      u.provider_uid = auth.uid
      u.provider_user_name = auth.info.name
      u.email = auth.info.email if user_by_provider
      u.role = "member"
      u.save(:validate => false)

      return u
    end


byebug
    # Case 3: Create new password
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.fb_name = auth.info.name
    user.fb_avatar = auth.info.image
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.fb_raw_data = auth
    user.save!
    return user
  end
  
  def is_guest?
    self.role == 'guest'
  end

  private

  def employee
    account = email.split("@").first
    unless employee_list.include?(account)
      errors[:name] << "如果有其他疑問，請聯絡管理員。"
    end
  end

  def employee_list
    [] # 用'',表示
  end
end