class ChangeNullToTrueInBills < ActiveRecord::Migration
  def change
    change_column_null :bills, :group_id, null: true
  end
end
