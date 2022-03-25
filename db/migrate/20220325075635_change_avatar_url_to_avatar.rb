class ChangeAvatarUrlToAvatar < ActiveRecord::Migration[7.0]
  def change
    rename_column :organizations, :avatar_url, :avatar
  end
end
