class InitialMigration < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :uri
      t.integer :upvote_count
      t.integer :downvote_count

      t.timestamps null: false
    end

    create_table :tags do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :links_tags, id: false do |t|
      t.belongs_to :link, index: true
      t.belongs_to :tag, index: true
    end

    add_foreign_key :links_tags, :tags
    add_foreign_key :links_tags, :links

    create_table :comments do |t|
      t.belongs_to :link, index: true
      t.string :body

      t.timestamps null: false
    end

    add_foreign_key :comments, :links
  end
end
