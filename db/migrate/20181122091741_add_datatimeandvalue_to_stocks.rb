class AddDatatimeandvalueToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :value, :decimal, precision: 8, scale: 2
    add_column :stocks, :datatime, :datetime
    add_reference :stocks, :user, foreign_key: true
  end
end
