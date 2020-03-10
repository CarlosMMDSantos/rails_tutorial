class CreateCreateTagsPostsRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :tags_posts_relationships do |t|
      t.integer :micropost_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :tags_posts_relationships, :micropost_id
    add_index :tags_posts_relationships, :tag_id
    add_index :tags_posts_relationships, [:micropost_id, :tag_id], unique: true
  end
end
