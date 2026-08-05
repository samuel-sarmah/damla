class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :customer_type, null: false, default: "individual"
      t.string :name, null: false
      t.string :phone, null: false
      t.string :email
      t.string :preferred_locale, null: false, default: "tr"
      t.string :created_via, null: false, default: "web"

      t.timestamps
    end
    add_index :customers, :phone, unique: true
  end
end
