class Company < ApplicationRecord
  has_many :stocks
  belongs_to :category
end
