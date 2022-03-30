class AddDonationIdToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :donation_id, :string, null: false

    add_index :donations, :donation_id, unique: true
  end
end
