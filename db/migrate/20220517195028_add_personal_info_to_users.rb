class AddPersonalInfoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :contact_no, :string, limit: 20
    add_column :users, :address, :text
    add_column :users, :birth_date, :datetime, precision: 0
    add_column :users, :gender, :integer

    change_column :users, :name, :string, limit: 63
  end
end
