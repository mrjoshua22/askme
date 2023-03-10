class User < ApplicationRecord
  include Gravtastic
  gravtastic(secure: true, filetype: :png, size: 100, default: 'retro')

  has_secure_password

  has_many :questions, dependent: :delete_all

  before_validation :downcase_nickname, :downcase_email

  validates :nickname, presence: true, length: { maximum: 40 },
    uniqueness: true, format: { with: /\A\w+\z/ }

  validates :email, presence: true, uniqueness: true,
    format: { with: /\A[a-z\d+.\-]+@[a-z\d-]+(\.[a-z\d\-]+)*\.[a-z]+\z/ }

  def to_param
    nickname
  end

  private

  def downcase_nickname
    nickname&.downcase!
  end

  def downcase_email
    email&.downcase!
  end
end
