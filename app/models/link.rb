class Link < ActiveRecord::Base
  has_many :comments
  has_many :tags, through: :links_tags

  validates :uri, presence: true
end
