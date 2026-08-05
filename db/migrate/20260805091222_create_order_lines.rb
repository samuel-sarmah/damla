class CreateOrderLines < ActiveRecord::Migration[8.1]
  def change
    create_table :order_lines do |t|
      t.references :delivery_order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price_try, precision: 10, scale: 2, null: false
      t.boolean :is_exchange, null: false, default: false
      t.decimal :deposit_delta_try, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
