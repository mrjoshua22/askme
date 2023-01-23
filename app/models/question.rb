class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_many :hashtag_questions, dependent: :delete_all
  has_many :hashtags, through: :hashtag_questions

  validates :body, presence: true, length: { maximum: 280 }

  after_commit :create_hashtag_questions, on: %i[create update]

  private

  def create_hashtag_questions
    extract_hashtag_names.each do |hashtag_name|
      hashtag_questions.create(
        hashtag: Hashtag.find_or_create_by(name: hashtag_name)
      )
    end
  end

  def extract_hashtag_names
    if answer.blank?
      hashtag_names(body)
    else
      hashtag_names(body).concat(hashtag_names(answer))
    end
  end

  def hashtag_names(string)
    string.scan(/#[[:word:]]+/).
      map {|hashtag| hashtag.gsub('#', '').downcase }.uniq
  end
end
