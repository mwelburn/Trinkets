class CreateTrinkets < ActiveRecord::Migration
  def change
    create_table :trinkets do |t|
      t.integer :user_id, :null => false
      t.text :name, :null => false
      t.text :description, :default => ""
      t.date :date_acquired
      t.integer :quantity
      t.integer :current_value
      t.text :serial_number, :default => ""

      t.timestamps
    end

    add_index :trinkets, :user_id
    add_index :trinkets, :name
    add_index :trinkets, :description
    add_index :trinkets, :date_acquired
    add_index :trinkets, :quantity
    add_index :trinkets, :current_value
    add_index :trinkets, :serial_number

    add_attachment :trinkets, :attachment
  end
end
