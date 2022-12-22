class User < ApplicationRecord
  has_secure_password

  before_validation :downcase_nickname

  validates :nickname, presence: true, length: { maximum: 40 },
    uniqueness: true, format: { with: /\A\w+\z/ }

  validates :email, presence: true, uniqueness: true,
    format: { with: /\A[a-z\d+.\-]+@[a-z\d-]+(\.[a-z\d\-]+)*\.[a-z]+\z/ }

  def downcase_nickname
    nickname.downcase!
  end
end
