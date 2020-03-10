class TagsPostsRelationship < ApplicationRecord
    belongs_to :micropost, class_name: "Micropost"
    belongs_to :tag, class_name: "Tag"

    validates :micropost_id, presence: true
    validates :tag_id, presence: true
end
