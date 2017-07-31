class AddPaneltoUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :panel_top, :float
    add_column :users, :panel_left, :float
  end
end
