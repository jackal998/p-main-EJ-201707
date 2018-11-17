class ChangeColumnNameandAddIndexOfUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :cookie_show_me_who_your_are, :show_me_who_u_r
    add_index :users, :provider_uid
  end
end
