class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    before_save { self.email = email.downcase }

    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    validates :phone, presence: true, length: { minimum: 9 }, numericality: { only_integer: true }
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    has_one :address, dependent: :destroy

    has_secure_password
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost 
        BCrypt::Password.create(string, cost: cost)
    end

    def feed
        part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
        Micropost.includes(:image_attachment, :user, :tags).joins(user: :followers).where(part_of_feed, { id: id }).group("microposts.id")
    end

    # Follows a user.
    def follow(other_user)
        following << other_user
    end
    # Unfollows a user.
    def unfollow(other_user)
        following.delete(other_user)
    end
    # Returns true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
    end

        
end
