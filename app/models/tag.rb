class Tag < ActiveRecord::Base
  has_many :links, through: :links_tags

  validates :name, presence: true
end
