class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|
      t.string :token, null: false
      t.timestamps
    end

    add_index :api_keys, :token, unique: true
    add_reference :api_keys, :organization, foreign_key: { on_delete: :cascade }, null: false
  end
end
