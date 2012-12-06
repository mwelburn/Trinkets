class CreateTrinketAttachments < ActiveRecord::Migration
  def change
    create_table :trinket_attachments do |t|
      t.integer :trinket_id, :null => false
      t.string :description, :default => ""

      t.timestamps
    end

    add_index :trinket_attachments, :trinket_id

    add_attachment :trinket_attachments, :attachment
  end
end
