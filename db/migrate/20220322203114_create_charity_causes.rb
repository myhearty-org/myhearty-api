class CreateCharityCauses < ActiveRecord::Migration[7.0]
  def change
    create_table :charity_causes do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.timestamps
    end

    create_table :charitable_categories, id: false do |t|
      t.bigint :charitable_id, null: false
      t.string :charitable_type, null: false
      t.timestamps
    end

    add_reference :charitable_categories, :charity_cause, foreign_key: { on_delete: :cascade }, null: false
    add_index :charitable_categories, [:charitable_id, :charitable_type, :charity_cause_id], unique: true, name: "index_charitable_categories"
  end
end
