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
      errors[:base] << "請詢問管理員！"
    end
  end

  def employee_list
    [
      'qazwsxedcrfvtgbyhnujmikolp'
    ]
  end
end