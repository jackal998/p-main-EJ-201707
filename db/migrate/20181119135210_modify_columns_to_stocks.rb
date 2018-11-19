class ModifyColumnsToStocks < ActiveRecord::Migration[5.0]
  change_table :stocks do |t|
	  t.remove :code, :integer
    t.remove :alias_name, :string
	  t.references :company
	end
end
