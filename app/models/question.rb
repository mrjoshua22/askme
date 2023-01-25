class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_many :hashtag_questions, dependent: :delete_all
  has_many :hashtags, through: :hashtag_questions

  validates :body, presence: true, length: { maximum: 280 }

  after_commit :create_hashtags, on: %i[create update]
  after_commit :remove_hashtags, on: :update

  private

  def remove_hashtags
    removed_hashtags =
      Hashtag.where(name: (hashtags.map(&:name) - extract_hashtag_names))

    hashtag_questions.where(hashtag_id: removed_hashtags).delete_all

    removed_hashtags.includes(:questions).each do |hashtag|
      hashtag.delete if hashtag.questions.empty?
    end
  end

  def create_hashtags
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
