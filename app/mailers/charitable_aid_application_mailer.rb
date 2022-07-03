# frozen_string_literal: true

class CharitableAidApplicationMailer < ApplicationMailer
  layout false

  before_action :set_charitable_aid_application_info

  def approval_email
    mail(
      to: email_address_with_name(@receiver.email, @receiver.name),
      subject: "#{@charitable_aid.name} Charitable Aid Application (Approved)"
    )
  end

  def rejection_email
    mail(
      to: email_address_with_name(@receiver.email, @receiver.name),
      subject: "#{@charitable_aid.name} Charitable Aid Application (Rejected)"
    )
  end

  private

  def set_charitable_aid_application_info
    @charitable_aid_application = params[:charitable_aid_application]
    @receiver = @charitable_aid_application.receiver
    @charitable_aid = @charitable_aid_application.charitable_aid
  end
end
