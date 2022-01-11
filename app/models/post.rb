class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  enum status: { published: 0, archived: 1 }
end
