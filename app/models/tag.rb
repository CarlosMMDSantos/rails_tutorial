class Tag < ApplicationRecord
  before_save { self.content = content.downcase }

  validates :content, presence: true, length: { maximum: 10 }, uniqueness: { case_sensitive: false }

  has_many :micropost_relations, class_name: "TagsPostsRelationship", dependent: :destroy
  has_many :microposts, through: :micropost_relations

  def to_s
    content
  end
end
