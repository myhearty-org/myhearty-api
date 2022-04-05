class ChangeSignUpDeadlineToApplicationDeadline < ActiveRecord::Migration[7.0]
  def change
    rename_column :volunteer_events, :sign_up_deadline, :application_deadline
  end
end
