class Link < ActiveRecord::Base
  has_many :comments
  # rubocop:disable HasAndBelongsToMany
  has_and_belongs_to_many :tags
  # rubocop:enable HasAndBelongsToMany

  validates :uri, presence: true
end
