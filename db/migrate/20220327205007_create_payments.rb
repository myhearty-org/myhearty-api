class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :stripe_checkout_session_id, null: false
      t.integer :gross_amount
      t.integer :fee
      t.integer :net_amount
      t.string :payment_method
      t.string :status, null: false
      t.datetime :completed_at
      t.timestamps
    end

    add_index :payments, :stripe_checkout_session_id
    add_index :payments, :gross_amount
    add_index :payments, :created_at
    add_index :payments, :completed_at

    add_reference :payments, :donation, foreign_key: true, null: false
    add_reference :payments, :fundraising_campaign, foreign_key: true, null: false
    add_reference :payments, :user, foreign_key: true, null: false
  end
end
