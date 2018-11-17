class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :provider_uid, :string
    add_column :users, :provider_user_name, :string
    add_column :users, :provider_avatar, :string
  end
end
