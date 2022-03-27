class RemoveColumnsFromDonations < ActiveRecord::Migration[7.0]
  def change
    remove_index :donations, name: "index_donations_on_payment_id"

    remove_column :donations, :payment_id
    remove_column :donations, :payment_method

    remove_column :donations, :date
    add_column :donations, :completed_at, :datetime

    add_index :donations, :completed_at
  end
end
