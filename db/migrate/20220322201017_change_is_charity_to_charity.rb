class ChangeIsCharityToCharity < ActiveRecord::Migration[7.0]
  def change
    rename_column :organizations, :is_charity, :charity
  end
end
