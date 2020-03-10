class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.string :address
      t.string :city
      t.string :zip_code
      t.string :country

      t.timestamps
    end
  end
end
