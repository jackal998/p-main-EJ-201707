class AddIndexToUser < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :cookie_show_me_who_your_are
  end
end
