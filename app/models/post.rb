class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
  validates :status, presence: true

  enum status: { published: 0, archived: 1 }
end
