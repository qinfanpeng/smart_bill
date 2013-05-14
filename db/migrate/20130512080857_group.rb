class Group < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :creater_id
      t.timestamps
    end
  end
end
