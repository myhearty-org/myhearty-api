class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.integer :amount, null: false
      t.string :payment_id, null: false
      t.string :payment_method, null: false
      t.datetime :date, null: false
      t.timestamps
    end

    add_reference :donations, :fundraising_campaign, foreign_key: true, null: false
    add_reference :donations, :user, foreign_key: true, null: false

    add_index :donations, :amount
    add_index :donations, :payment_id
    add_index :donations, :date
  end
end
