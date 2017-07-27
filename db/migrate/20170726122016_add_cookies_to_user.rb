class AddCookiesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cookie_show_me_who_your_are, :string
  end
end
