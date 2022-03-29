class ChangeOrganizations < ActiveRecord::Migration[7.0]
  def change
    change_column :organizations, :name, :string, limit: 63, null: false
    change_column :organizations, :email, :string, limit: 63, null: false
    change_column :organizations, :contact_no, :string, limit: 20, null: false
    change_column :organizations, :person_in_charge_name, :string, limit: 63, null: false
  end
end
