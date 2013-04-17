class CreateGoodNames < ActiveRecord::Migration
  def change
    create_table :good_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
