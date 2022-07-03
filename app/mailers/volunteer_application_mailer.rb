# frozen_string_literal: true

class VolunteerApplicationMailer < ApplicationMailer
  layout false

  before_action :set_volunteer_application_info

  def confirmation_email
    mail(
      to: email_address_with_name(@volunteer.email, @volunteer.name),
      subject: "#{@volunteer_event.name} Volunteer Application (Confirmed)"
    )
  end

  def rejection_email
    mail(
      to: email_address_with_name(@volunteer.email, @volunteer.name),
      subject: "#{@volunteer_event.name} Volunteer Application (Rejected)"
    )
  end

  private

  def set_volunteer_application_info
    @volunteer_application = params[:volunteer_application]
    @volunteer = @volunteer_application.volunteer
    @volunteer_event = @volunteer_application.volunteer_event
  end
end
