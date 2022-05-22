class AddReasonToCharitableAidApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :charitable_aid_applications, :reason, :text, null: false, default: ""
  end
end
