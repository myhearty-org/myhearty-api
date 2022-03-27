Pay.setup do |config|
  # For use in the receipt/refund/renewal mailers
  config.business_name = "MyHearty"

  config.business_address = "Kuala Lumpur, Malaysia"

  config.application_name = "MyHearty"

  config.support_email = "support@myhearty.my"

  config.default_product_name = "default"

  config.default_plan_name = "default"

  config.automount_routes = false

  # Only when automount_routes is true
  config.routes_path = "/pay"

  # All processors are enabled by default. If a processor is already implemented in your application,
  # you can omit it from this list and the processor will not be set up through the Pay gem.
  # config.enabled_processors = [:stripe]

  # All emails can be configured independently as to whether to be sent or not. The values can be set
  # to true, false or a custom lambda to set up more involved logic. The Pay defaults are shown below
  # and can be modified as needed.
  # config.emails.payment_action_required = true

  # config.emails.receipt = true

  # config.emails.refund = true

  # This example for subscription_renewing only applies to Stripe, therefor we supply the second argument of price
  # config.emails.subscription_renewing = ->(pay_subscription, price) {
  #   (price&.type == "recurring") && (price.recurring&.interval == "year")
  # }
end
