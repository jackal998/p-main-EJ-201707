class AddVolumeToStocks < ActiveRecord::Migration[5.0]
  def change
    add_column :stocks, :volume, :integer
    add_index :stocks, :data_datetime, unique: true
  end
end
