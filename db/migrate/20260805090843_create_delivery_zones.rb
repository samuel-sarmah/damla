class CreateDeliveryZones < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_zones do |t|
      t.string :district, null: false
      t.boolean :active, null: false, default: true
      t.string :delivery_days, array: true, default: []

      t.timestamps
    end
    add_index :delivery_zones, :district, unique: true
  end
end
