class Tag < ActiveRecord::Base
  has_many :links

  validates :name, presence: true
end
