class Tag < ActiveRecord::Base
  # rubocop:disable HasAndBelongsToMany
  has_and_belongs_to_many :links
  # rubocop:enable HasAndBelongsToMany

  validates :name, presence: true
end
