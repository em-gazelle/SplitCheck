class AddIndContributionToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :individual_contribution, :integer
  end
end
