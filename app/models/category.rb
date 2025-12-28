class Category < ApplicationRecord
  has_many :contents, dependent: :destroy
  has_many :moods

  validates :name, presence: true, uniqueness: true

  CATEGORIES = %w[uplifting calming motivational serious]
end
