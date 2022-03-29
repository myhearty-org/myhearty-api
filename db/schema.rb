# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_29_205604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charitable_aid_applications", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.datetime "status_updated_at", precision: 6, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "charitable_aid_id", null: false
    t.bigint "receiver_id", null: false
    t.index ["charitable_aid_id", "receiver_id"], name: "index_charitable_aid_applications", unique: true
    t.index ["charitable_aid_id"], name: "index_charitable_aid_applications_on_charitable_aid_id"
    t.index ["receiver_id"], name: "index_charitable_aid_applications_on_receiver_id"
    t.index ["status"], name: "index_charitable_aid_applications_on_status"
  end

  create_table "charitable_aids", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "url"
    t.integer "openings"
    t.integer "receiver_count", default: 0, null: false
    t.text "location"
    t.text "about_aid"
    t.string "main_image"
    t.string "youtube_url"
    t.datetime "application_deadline", precision: 0
    t.boolean "published", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id", null: false
    t.index ["name"], name: "index_charitable_aids_on_name"
    t.index ["organization_id"], name: "index_charitable_aids_on_organization_id"
  end

  create_table "charitable_categories", id: false, force: :cascade do |t|
    t.bigint "charitable_id", null: false
    t.string "charitable_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "charity_cause_id", null: false
    t.index ["charitable_id", "charitable_type", "charity_cause_id"], name: "index_charitable_categories", unique: true
    t.index ["charity_cause_id"], name: "index_charitable_categories_on_charity_cause_id"
  end

  create_table "charity_causes", force: :cascade do |t|
    t.string "name", null: false
    t.string "display_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "donations", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "fundraising_campaign_id", null: false
    t.bigint "donor_id", null: false
    t.index ["amount"], name: "index_donations_on_amount"
    t.index ["donor_id"], name: "index_donations_on_donor_id"
    t.index ["fundraising_campaign_id"], name: "index_donations_on_fundraising_campaign_id"
  end

  create_table "fundraising_campaigns", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "url"
    t.integer "target_amount"
    t.integer "total_raised_amount", default: 0, null: false
    t.integer "donor_count", default: 0, null: false
    t.text "location"
    t.text "about_campaign"
    t.string "main_image"
    t.string "youtube_url"
    t.datetime "start_datetime", precision: 0
    t.datetime "end_datetime", precision: 0
    t.boolean "published", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id", null: false
    t.string "stripe_product_id"
    t.index ["name"], name: "index_fundraising_campaigns_on_name"
    t.index ["organization_id"], name: "index_fundraising_campaigns_on_organization_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
    t.index ["provider", "user_id"], name: "index_identities_on_provider_and_user_id", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: 6
    t.datetime "last_sign_in_at", precision: 6
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: 6
    t.datetime "confirmation_sent_at", precision: 6
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id", null: false
    t.boolean "admin", default: false, null: false
    t.index ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["organization_id"], name: "index_members_on_organization_id"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_members_on_unlock_token", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", limit: 63, null: false
    t.text "location", null: false
    t.string "email", limit: 63, null: false
    t.string "contact_no", limit: 20, null: false
    t.string "website_url"
    t.string "facebook_url"
    t.string "youtube_url"
    t.string "person_in_charge_name", limit: 63, null: false
    t.string "avatar"
    t.string "video_url"
    t.string "images", default: [], array: true
    t.text "about_us", null: false
    t.text "programmes_summary"
    t.boolean "charity", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_account_id"
    t.index ["email"], name: "index_organizations_on_email", unique: true
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["website_url"], name: "index_organizations_on_website_url", unique: true
  end

  create_table "pay_charges", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "subscription_id"
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.string "currency"
    t.integer "application_fee_amount"
    t.integer "amount_refunded"
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
    t.index ["subscription_id"], name: "index_pay_charges_on_subscription_id"
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_type", "owner_id", "deleted_at", "default"], name: "pay_customer_owner_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id", unique: true
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "processor_id", null: false
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", null: false
    t.datetime "trial_ends_at", precision: 6
    t.datetime "ends_at", precision: 6
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "stripe_checkout_session_id", null: false
    t.integer "gross_amount"
    t.integer "fee"
    t.integer "net_amount"
    t.string "payment_method"
    t.string "status", null: false
    t.datetime "completed_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "donation_id", null: false
    t.bigint "fundraising_campaign_id", null: false
    t.bigint "user_id", null: false
    t.index ["completed_at"], name: "index_payments_on_completed_at"
    t.index ["created_at"], name: "index_payments_on_created_at"
    t.index ["donation_id"], name: "index_payments_on_donation_id"
    t.index ["fundraising_campaign_id"], name: "index_payments_on_fundraising_campaign_id"
    t.index ["gross_amount"], name: "index_payments_on_gross_amount"
    t.index ["stripe_checkout_session_id"], name: "index_payments_on_stripe_checkout_session_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: 6
    t.datetime "last_sign_in_at", precision: 6
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: 6
    t.datetime "confirmation_sent_at", precision: 6
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: 6
    t.string "name"
    t.string "avatar"
    t.string "facebook_username"
    t.string "google_oauth2_username"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["facebook_username"], name: "index_users_on_facebook_username"
    t.index ["google_oauth2_username"], name: "index_users_on_google_oauth2_username"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "volunteer_applications", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.datetime "status_updated_at", precision: 6, null: false
    t.integer "attendance", default: 0, null: false
    t.datetime "attendance_updated_at", precision: 6, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "volunteer_event_id", null: false
    t.bigint "volunteer_id", null: false
    t.index ["attendance"], name: "index_volunteer_applications_on_attendance"
    t.index ["status"], name: "index_volunteer_applications_on_status"
    t.index ["volunteer_event_id", "volunteer_id"], name: "index_volunteer_applications", unique: true
    t.index ["volunteer_event_id"], name: "index_volunteer_applications_on_volunteer_event_id"
    t.index ["volunteer_id"], name: "index_volunteer_applications_on_volunteer_id"
  end

  create_table "volunteer_events", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "url"
    t.integer "openings"
    t.integer "volunteer_count", default: 0, null: false
    t.text "location"
    t.text "about_event"
    t.string "main_image"
    t.string "youtube_url"
    t.datetime "start_datetime", precision: 0
    t.datetime "end_datetime", precision: 0
    t.datetime "sign_up_deadline", precision: 0
    t.boolean "published", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id", null: false
    t.index ["name"], name: "index_volunteer_events_on_name"
    t.index ["organization_id"], name: "index_volunteer_events_on_organization_id"
  end

  add_foreign_key "charitable_aid_applications", "charitable_aids"
  add_foreign_key "charitable_aid_applications", "users", column: "receiver_id"
  add_foreign_key "charitable_aids", "organizations", on_delete: :cascade
  add_foreign_key "charitable_categories", "charity_causes", on_delete: :cascade
  add_foreign_key "donations", "fundraising_campaigns"
  add_foreign_key "donations", "users", column: "donor_id"
  add_foreign_key "fundraising_campaigns", "organizations", on_delete: :cascade
  add_foreign_key "identities", "users", on_delete: :cascade
  add_foreign_key "members", "organizations", on_delete: :cascade
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_charges", "pay_subscriptions", column: "subscription_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "payments", "donations"
  add_foreign_key "payments", "fundraising_campaigns"
  add_foreign_key "payments", "users"
  add_foreign_key "volunteer_applications", "users", column: "volunteer_id"
  add_foreign_key "volunteer_applications", "volunteer_events"
  add_foreign_key "volunteer_events", "organizations", on_delete: :cascade
end
