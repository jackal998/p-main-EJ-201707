class AddCategoryKeyToCompany < ActiveRecord::Migration[5.0]
  def change
    change_table :companies do |t|
      t.references :category
    end
  end
end
