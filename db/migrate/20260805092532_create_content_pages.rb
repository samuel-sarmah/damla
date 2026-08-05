class CreateContentPages < ActiveRecord::Migration[8.1]
  def change
    create_table :content_pages do |t|
      t.string :slug, null: false

      t.timestamps
    end
    add_index :content_pages, :slug, unique: true
  end
end
