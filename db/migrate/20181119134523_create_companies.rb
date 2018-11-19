class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
  		t.integer :code
  		t.string :alias_name
			t.string :full_name
			t.string :description
      t.timestamps
    end
  end
end
