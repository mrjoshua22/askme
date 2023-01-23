class Hashtag < ApplicationRecord
  has_many :hashtag_questions, dependent: :delete_all
  has_many :questions, through: :hashtag_questions

  validates :name, uniqueness: true
end
