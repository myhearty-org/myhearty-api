class AddOrganizationRefToMembers < ActiveRecord::Migration[7.0]
  def change
    add_reference :members, :organization, foreign_key: { on_delete: :cascade }, null: false
  end
end
