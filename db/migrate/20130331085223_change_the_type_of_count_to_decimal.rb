class ChangeTheTypeOfCountToDecimal < ActiveRecord::Migration
  def change
    change_column :bills, :count, :decimal
  end
end
