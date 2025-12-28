# app/models/interaction.rb
class Interaction < ApplicationRecord
  belongs_to :user
  belongs_to :mood
  belongs_to :category

  enum :content_type, { quote: 0, blog: 1, music: 2, picture: 3 }

  validates :timestamp, presence: true

  scope :recent, -> { where('timestamp >= ?', 30.days.ago) }
  scope :for_user, ->(user) { where(user: user) }
end
