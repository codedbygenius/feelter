class JournalEntry < ApplicationRecord
  belongs_to :user
  belongs_to :mood

  validates :mood, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :for_feeling, ->(feeling) { joins(:mood).where(moods: { feeling: feeling }) }
end
