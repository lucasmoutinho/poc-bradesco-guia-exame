class Contract < ApplicationRecord
  belongs_to :provider
  has_and_belongs_to_many :prices
end
