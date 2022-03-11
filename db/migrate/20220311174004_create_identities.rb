class CreateIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :uid
      t.timestamps
    end

    add_reference :identities, :user, foreign_key: { on_delete: :cascade }, null: false

    add_index :identities, [:provider, :uid], unique: true
    add_index :identities, [:provider, :user_id], unique: true
  end
end
