class CreateOverlays < ActiveRecord::Migration[5.2]
  def change
    create_table :overlays do |t|
      t.string :name
      t.text :body
      t.string :sc_hash
      t.integer :sc_order

      t.timestamps
    end
  end
end
