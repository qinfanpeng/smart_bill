class AddBillIdToGoodInformations < ActiveRecord::Migration
  def change
    add_column :good_informations, :bill_id, :integer
  end
end
