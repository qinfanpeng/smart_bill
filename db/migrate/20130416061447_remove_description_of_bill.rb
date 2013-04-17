class RemoveDescriptionOfBill < ActiveRecord::Migration
  def change
    remove_column :bills, :description
  end
end
