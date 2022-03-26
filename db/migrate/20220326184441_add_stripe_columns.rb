class AddStripeColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :stripe_account_id, :string
    add_column :fundraising_campaigns, :stripe_product_id, :string
  end
end
