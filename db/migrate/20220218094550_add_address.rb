class AddAddress < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string  :city, null: false
      t.string :street
      t.integer :house_number
      t.references :contact, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
