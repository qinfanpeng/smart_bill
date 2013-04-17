class ChangeTheTypeOfAmountToStrin < ActiveRecord::Migration
  def change
    change_column :good_informations, :amount, :string
  end
end
