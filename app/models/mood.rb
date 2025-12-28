class Mood < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :contents, dependent: :nullify
  has_many :journal_entries, dependent: :destroy

  enum :feeling, { happy: 0, sad: 1, meh: 2 }

  validates :feeling, presence: true

  FEELING_EMOJIS = {
    'happy' => '😊',
    'sad' => '😢',
    'meh' => '😐'
  }
end
