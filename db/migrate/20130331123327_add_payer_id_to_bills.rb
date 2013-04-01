class AddPayerIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :payer_id, :Integer
  end
end
