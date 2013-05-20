class AddGroupId2Bills < ActiveRecord::Migration
  def change
    change_table :bills do |t|
      t.integer :group_id, null: false, :default => 0
    end
  end
end
