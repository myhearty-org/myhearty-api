class AddEmailsToVolunteerEventsAndCharitableAids < ActiveRecord::Migration[7.0]
  def change
    add_column :volunteer_events, :confirmation_email_body, :text, default: ""
    add_column :charitable_aids, :approval_email_body, :text, default: ""
  end
end
