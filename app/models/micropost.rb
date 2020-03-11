class Micropost < ApplicationRecord
    validates :content, length: { maximum: 140 }, presence: true
    validates :user_id, presence: true
    validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" },
        size: { less_than: 5.megabytes, message:   "should be less than 5MB" }
 
    belongs_to :user

    has_many :tags_posts_relationships, dependent: :destroy
    has_many :tags, through: :tags_posts_relationships

    has_one_attached :image
    default_scope -> { order(created_at: :desc) }

    # Returns a resized image for display.
    def display_image
        image.variant(resize_to_limit: [500, 500])
    end

    def addTag(tag)
        tags << tag
    end

    def removeTag(tag)
        tags.delete(tag)
    end
end
