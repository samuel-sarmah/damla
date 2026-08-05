class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :sku, null: false
      t.decimal :size_liters, precision: 4, scale: 2, null: false
      t.string :unit_type, null: false, default: "retail_pack"
      t.boolean :requires_deposit, null: false, default: false
      t.decimal :base_price_try, precision: 10, scale: 2, null: false
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
