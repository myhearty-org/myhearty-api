class ChangeDonations < ActiveRecord::Migration[7.0]
  def change
    remove_column :donations, :completed_at, :datetime

    remove_column :donations, :user_id, :bigint
    add_reference :donations, :donor, foreign_key: { to_table: :users }, null: false
  end
end
