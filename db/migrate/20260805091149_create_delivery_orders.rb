class CreateDeliveryOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.string :order_source, null: false, default: "web"
      t.string :status, null: false, default: "pending"
      t.date :scheduled_date
      t.datetime :delivered_at
      t.text :notes

      t.timestamps
    end
    add_index :delivery_orders, :status
    add_index :delivery_orders, :created_at
  end
end
