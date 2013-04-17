class GoodInformations < ActiveRecord::Migration
  def change
    create_table :good_informations do |t|
      t.decimal :amount
      t.decimal :price
      t.integer :good_name_id

      t.timestamps
    end
  end
end
