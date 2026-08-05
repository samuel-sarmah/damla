class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :district, null: false
      t.string :sub_district
      t.text :free_text_description, null: false
      t.decimal :geo_lat, precision: 10, scale: 6
      t.decimal :geo_lng, precision: 10, scale: 6
      t.text :delivery_notes

      t.timestamps
    end
    add_index :addresses, :district
  end
end
