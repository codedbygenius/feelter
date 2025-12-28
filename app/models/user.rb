class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :moods, dependent: :destroy
  has_many :journal_entries, dependent: :destroy
  has_many :interactions, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :moods, dependent: :destroy



  validates :first_name, :last_name, presence: true
end
