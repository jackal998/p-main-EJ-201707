class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :employee

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