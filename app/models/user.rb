class User < ApplicationRecord
  has_many :posts

  validates :email, presence: true
  validates :name, presence: true
  validates :auth_token, presence: true

  after_initialize :generate_auth_token

  private

  def generate_auth_token
    self.auth_token = TokenGenerationService.generate unless auth_token.present?
  end
end
