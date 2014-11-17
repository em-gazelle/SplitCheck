class AddVenmoToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :audience, :string
  	add_column :transactions, :phone_number_charged, :string
  end
end
