class AddImageData < ActiveRecord::Migration[7.0]
  def change
    remove_column :fundraising_campaigns, :main_image, :string
    add_column :fundraising_campaigns, :image_data, :text

    remove_column :volunteer_events, :main_image, :string
    add_column :volunteer_events, :image_data, :text

    remove_column :charitable_aids, :main_image, :string
    add_column :charitable_aids, :image_data, :text

    remove_column :organizations, :avatar, :string
    add_column :organizations, :avatar_data, :text

    remove_column :organizations, :images, :string, default: [], array: true
    add_column :organizations, :image_data, :text

    remove_column :users, :avatar, :string
    add_column :users, :avatar_data, :text

    add_column :members, :avatar_data, :text
  end
end
