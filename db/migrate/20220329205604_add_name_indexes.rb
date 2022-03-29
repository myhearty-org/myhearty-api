class AddNameIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :fundraising_campaigns, :name
    add_index :volunteer_events, :name
    add_index :charitable_aids, :name
  end
end
