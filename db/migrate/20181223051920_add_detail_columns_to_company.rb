class AddDetailColumnsToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :chairman, :string
    add_column :companies, :president, :string
    add_column :companies, :establishment, :datetime
    add_column :companies, :listed_date, :datetime
    add_column :companies, :tax_ID, :string
  end
end
