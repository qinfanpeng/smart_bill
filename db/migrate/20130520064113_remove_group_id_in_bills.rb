class RemoveGroupIdInBills < ActiveRecord::Migration
  def change
    remove_column :bills, :group_id
  end
end
