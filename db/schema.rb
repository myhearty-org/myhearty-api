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

ActiveRecord::Schema.define(version: 2022_03_23_163445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "fundraising_campaigns", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "url"
    t.integer "target_amount", default: 0, null: false
    t.integer "total_raised_amount", default: 0, null: false
    t.integer "total_donors", default: 0, null: false
    t.text "location"
    t.text "about_campaign"
    t.string "main_image"
    t.string "youtube_url"
    t.datetime "start_datetime", precision: 6
    t.datetime "end_datetime", precision: 6
    t.boolean "published", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organization_id", null: false
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
    t.string "name", null: false
    t.text "location", null: false
    t.string "email", null: false
    t.string "contact_no", null: false
    t.string "website_url"
    t.string "facebook_url"
    t.string "youtube_url"
    t.string "person_in_charge_name", null: false
    t.string "avatar_url"
    t.string "video_url"
    t.string "images", default: [], array: true
    t.text "about_us", null: false
    t.text "programmes_summary"
    t.boolean "charity", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_organizations_on_email", unique: true
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["website_url"], name: "index_organizations_on_website_url", unique: true
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

  add_foreign_key "charitable_categories", "charity_causes", on_delete: :cascade
  add_foreign_key "fundraising_campaigns", "organizations", on_delete: :cascade
  add_foreign_key "identities", "users", on_delete: :cascade
  add_foreign_key "members", "organizations", on_delete: :cascade
end
