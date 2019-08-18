class User < ApplicationRecord

  before_create { self.access_token_expired_at = DateTime.now + 3.month }

  has_secure_token :access_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  validates :userid, presence: true, uniqueness: true, length: { maximum: 20 }, format: { with: /\A[a-z0-9]+\z/, message: "半角英数(小文字)のみが使えます" }
  validates :email, confirmation: true
  validates :email_confirmation, presence: true

end
