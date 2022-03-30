class RenameCharitableCategories < ActiveRecord::Migration[7.0]
  def change
    rename_table :charitable_categories, :charitables_charity_causes

    rename_index :charitables_charity_causes, "index_charitable_categories", "index_charitables_charity_causes"
  end
end
