class AddBasicdataToStocks < ActiveRecord::Migration[5.0]
  def change
  	# precision is the total number of digits
  	# scale is the number of digits to the right of the decimal point
  	# number_to_currency(price, :unit => "€")
	
  	add_column :stocks, :data_datetime, :datetime
  	add_column :stocks, :code, :integer
  	add_column :stocks, :alias_name, :string
    add_column :stocks, :price, :decimal, :precision => 8, :scale => 2
  end
end
