class Link < ActiveRecord::Base
  has_many :comments
  has_many :tags

  validates :uri, presence: true
end
