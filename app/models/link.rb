class Link < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :links_tags
  has_many :tags, through: :links_tags

  validates :uri, presence: true
end
