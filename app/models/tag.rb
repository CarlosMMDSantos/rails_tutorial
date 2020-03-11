class Tag < ApplicationRecord
  before_save { self.content = content.downcase }

  validates :content, presence: true, length: { maximum: 10 }, uniqueness: { case_sensitive: false }

  has_many :tags_posts_relationships, dependent: :destroy
  has_many :microposts, through: :tags_posts_relationships

  def to_s
    content
  end
end
