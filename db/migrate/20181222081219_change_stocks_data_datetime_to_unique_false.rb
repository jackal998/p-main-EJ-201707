class ChangeStocksDataDatetimeToUniqueFalse < ActiveRecord::Migration[5.0]
  def change
    remove_index :stocks, :data_datetime
    add_index :stocks, :data_datetime, unique: false
  end
end
