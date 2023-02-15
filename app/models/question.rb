class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_many :hashtag_questions, dependent: :delete_all
  has_many :hashtags, through: :hashtag_questions

  validates :body, presence: true, length: { maximum: 280 }

  after_commit :update_hashtags, on: %i[create update]


  private

  def update_hashtags
    self.hashtags =
      "#{body} #{answer}".downcase.scan(Hashtag::REGEX).uniq.map do |tag|
        Hashtag.find_or_create_by(name: tag.delete('#'))
      end
  end
end
