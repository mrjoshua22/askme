class User < ApplicationRecord
  has_secure_password

  before_validation :downcase_nickname, :downcase_email

  validates :nickname, presence: true, length: { maximum: 40 },
    uniqueness: true, format: { with: /\A\w+\z/ }

  validates :email, presence: true, uniqueness: true,
    format: { with: /\A[a-z\d+.\-]+@[a-z\d-]+(\.[a-z\d\-]+)*\.[a-z]+\z/ }

  private

  def downcase_nickname
    nickname&.downcase!
  end

  def downcase_email
    email&.downcase!
  end
end
