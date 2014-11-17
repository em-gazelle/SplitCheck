class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :pre_tip_cost
      t.string :note
      t.integer :number_splitting
      t.integer :tip_percentage
      t.integer :post_tip

      t.timestamps
    end
  end
end
