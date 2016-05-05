# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160505084455) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "capchas", force: :cascade do |t|
    t.string   "phone",      limit: 255
    t.string   "type",       limit: 255
    t.datetime "expired_at"
    t.datetime "deleted_at"
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "client_id",  limit: 4
  end

  add_index "capchas", ["client_id"], name: "index_capchas_on_client_id", using: :btree
  add_index "capchas", ["phone"], name: "index_capchas_on_phone", using: :btree
  add_index "capchas", ["type"], name: "index_capchas_on_type", using: :btree

  create_table "card_tpl_groups", force: :cascade do |t|
    t.integer  "card_tpl_id", limit: 4
    t.integer  "group_id",    limit: 4
    t.integer  "client_id",   limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "card_tpl_groups", ["card_tpl_id"], name: "index_card_tpl_groups_on_card_tpl_id", using: :btree
  add_index "card_tpl_groups", ["client_id"], name: "index_card_tpl_groups_on_client_id", using: :btree
  add_index "card_tpl_groups", ["group_id"], name: "index_card_tpl_groups_on_group_id", using: :btree

  create_table "card_tpl_histories", force: :cascade do |t|
    t.integer  "card_tpl_id", limit: 4
    t.integer  "number",      limit: 4
    t.integer  "member_id",   limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "card_tpl_histories", ["card_tpl_id"], name: "index_card_tpl_histories_on_card_tpl_id", using: :btree
  add_index "card_tpl_histories", ["member_id"], name: "index_card_tpl_histories_on_member_id", using: :btree

  create_table "card_tpl_settings", force: :cascade do |t|
    t.integer  "card_tpl_id",       limit: 4
    t.boolean  "check_monday"
    t.boolean  "check_tuesday"
    t.boolean  "check_wednesday"
    t.boolean  "check_thursday"
    t.boolean  "check_friday"
    t.boolean  "check_saturday"
    t.boolean  "check_sunday"
    t.boolean  "acquire_monday"
    t.boolean  "acquire_tuesday"
    t.boolean  "acquire_wednesday"
    t.boolean  "acquire_thursday"
    t.boolean  "acquire_friday"
    t.boolean  "acquire_saturday"
    t.boolean  "acquire_sunday"
    t.boolean  "check_h0"
    t.boolean  "check_h1"
    t.boolean  "check_h2"
    t.boolean  "check_h3"
    t.boolean  "check_h4"
    t.boolean  "check_h5"
    t.boolean  "check_h6"
    t.boolean  "check_h7"
    t.boolean  "check_h8"
    t.boolean  "check_h9"
    t.boolean  "check_h10"
    t.boolean  "check_h11"
    t.boolean  "check_h12"
    t.boolean  "check_h13"
    t.boolean  "check_h14"
    t.boolean  "check_h15"
    t.boolean  "check_h16"
    t.boolean  "check_h17"
    t.boolean  "check_h18"
    t.boolean  "check_h19"
    t.boolean  "check_h20"
    t.boolean  "check_h21"
    t.boolean  "check_h22"
    t.boolean  "check_h23"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "card_tpl_settings", ["acquire_friday"], name: "index_card_tpl_settings_on_acquire_friday", using: :btree
  add_index "card_tpl_settings", ["acquire_monday"], name: "index_card_tpl_settings_on_acquire_monday", using: :btree
  add_index "card_tpl_settings", ["acquire_saturday"], name: "index_card_tpl_settings_on_acquire_saturday", using: :btree
  add_index "card_tpl_settings", ["acquire_sunday"], name: "index_card_tpl_settings_on_acquire_sunday", using: :btree
  add_index "card_tpl_settings", ["acquire_thursday"], name: "index_card_tpl_settings_on_acquire_thursday", using: :btree
  add_index "card_tpl_settings", ["acquire_tuesday"], name: "index_card_tpl_settings_on_acquire_tuesday", using: :btree
  add_index "card_tpl_settings", ["acquire_wednesday"], name: "index_card_tpl_settings_on_acquire_wednesday", using: :btree
  add_index "card_tpl_settings", ["card_tpl_id"], name: "index_card_tpl_settings_on_card_tpl_id", using: :btree
  add_index "card_tpl_settings", ["check_friday"], name: "index_card_tpl_settings_on_check_friday", using: :btree
  add_index "card_tpl_settings", ["check_h0"], name: "index_card_tpl_settings_on_check_h0", using: :btree
  add_index "card_tpl_settings", ["check_h1"], name: "index_card_tpl_settings_on_check_h1", using: :btree
  add_index "card_tpl_settings", ["check_h10"], name: "index_card_tpl_settings_on_check_h10", using: :btree
  add_index "card_tpl_settings", ["check_h11"], name: "index_card_tpl_settings_on_check_h11", using: :btree
  add_index "card_tpl_settings", ["check_h12"], name: "index_card_tpl_settings_on_check_h12", using: :btree
  add_index "card_tpl_settings", ["check_h13"], name: "index_card_tpl_settings_on_check_h13", using: :btree
  add_index "card_tpl_settings", ["check_h14"], name: "index_card_tpl_settings_on_check_h14", using: :btree
  add_index "card_tpl_settings", ["check_h15"], name: "index_card_tpl_settings_on_check_h15", using: :btree
  add_index "card_tpl_settings", ["check_h16"], name: "index_card_tpl_settings_on_check_h16", using: :btree
  add_index "card_tpl_settings", ["check_h17"], name: "index_card_tpl_settings_on_check_h17", using: :btree
  add_index "card_tpl_settings", ["check_h18"], name: "index_card_tpl_settings_on_check_h18", using: :btree
  add_index "card_tpl_settings", ["check_h19"], name: "index_card_tpl_settings_on_check_h19", using: :btree
  add_index "card_tpl_settings", ["check_h2"], name: "index_card_tpl_settings_on_check_h2", using: :btree
  add_index "card_tpl_settings", ["check_h20"], name: "index_card_tpl_settings_on_check_h20", using: :btree
  add_index "card_tpl_settings", ["check_h21"], name: "index_card_tpl_settings_on_check_h21", using: :btree
  add_index "card_tpl_settings", ["check_h22"], name: "index_card_tpl_settings_on_check_h22", using: :btree
  add_index "card_tpl_settings", ["check_h23"], name: "index_card_tpl_settings_on_check_h23", using: :btree
  add_index "card_tpl_settings", ["check_h3"], name: "index_card_tpl_settings_on_check_h3", using: :btree
  add_index "card_tpl_settings", ["check_h4"], name: "index_card_tpl_settings_on_check_h4", using: :btree
  add_index "card_tpl_settings", ["check_h5"], name: "index_card_tpl_settings_on_check_h5", using: :btree
  add_index "card_tpl_settings", ["check_h6"], name: "index_card_tpl_settings_on_check_h6", using: :btree
  add_index "card_tpl_settings", ["check_h7"], name: "index_card_tpl_settings_on_check_h7", using: :btree
  add_index "card_tpl_settings", ["check_h8"], name: "index_card_tpl_settings_on_check_h8", using: :btree
  add_index "card_tpl_settings", ["check_h9"], name: "index_card_tpl_settings_on_check_h9", using: :btree
  add_index "card_tpl_settings", ["check_monday"], name: "index_card_tpl_settings_on_check_monday", using: :btree
  add_index "card_tpl_settings", ["check_saturday"], name: "index_card_tpl_settings_on_check_saturday", using: :btree
  add_index "card_tpl_settings", ["check_sunday"], name: "index_card_tpl_settings_on_check_sunday", using: :btree
  add_index "card_tpl_settings", ["check_thursday"], name: "index_card_tpl_settings_on_check_thursday", using: :btree
  add_index "card_tpl_settings", ["check_tuesday"], name: "index_card_tpl_settings_on_check_tuesday", using: :btree
  add_index "card_tpl_settings", ["check_wednesday"], name: "index_card_tpl_settings_on_check_wednesday", using: :btree

  create_table "card_tpl_shops", force: :cascade do |t|
    t.integer  "card_tpl_id", limit: 4
    t.integer  "shop_id",     limit: 4
    t.integer  "client_id",   limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "card_tpl_shops", ["card_tpl_id"], name: "index_card_tpl_shops_on_card_tpl_id", using: :btree
  add_index "card_tpl_shops", ["client_id"], name: "index_card_tpl_shops_on_client_id", using: :btree
  add_index "card_tpl_shops", ["shop_id"], name: "index_card_tpl_shops_on_shop_id", using: :btree

  create_table "card_tpls", force: :cascade do |t|
    t.integer  "client_id",                limit: 4
    t.string   "title",                    limit: 255
    t.string   "short_desc",               limit: 255
    t.string   "desc",                     limit: 255
    t.string   "intro",                    limit: 255
    t.string   "type",                     limit: 255
    t.string   "indate_type",              limit: 255
    t.datetime "indate_from"
    t.datetime "indate_to"
    t.integer  "indate_after",             limit: 4
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "cover_file_name",          limit: 255
    t.string   "cover_content_type",       limit: 255
    t.integer  "cover_file_size",          limit: 4
    t.datetime "cover_updated_at"
    t.string   "share_cover_file_name",    limit: 255
    t.string   "share_cover_content_type", limit: 255
    t.integer  "share_cover_file_size",    limit: 4
    t.datetime "share_cover_updated_at"
    t.string   "guide_cover_file_name",    limit: 255
    t.string   "guide_cover_content_type", limit: 255
    t.integer  "guide_cover_file_size",    limit: 4
    t.datetime "guide_cover_updated_at"
    t.integer  "member_id",                limit: 4
    t.boolean  "indate_today"
    t.string   "website",                  limit: 255
    t.string   "check_weeks",              limit: 255
    t.string   "check_hours",              limit: 255
    t.string   "draw_type",                limit: 255
    t.integer  "prediction",               limit: 4
    t.string   "state",                    limit: 255, default: "active"
    t.integer  "total",                    limit: 4,   default: 0
    t.integer  "remain",                   limit: 4,   default: 0
    t.integer  "person_limit",             limit: 4,   default: 1
    t.datetime "acquire_from"
    t.datetime "acquire_to"
    t.string   "acquire_weeks",            limit: 255
    t.boolean  "public"
    t.boolean  "allow_share"
  end

  add_index "card_tpls", ["allow_share"], name: "index_card_tpls_on_allow_share", using: :btree
  add_index "card_tpls", ["client_id"], name: "index_card_tpls_on_client_id", using: :btree
  add_index "card_tpls", ["draw_type"], name: "index_card_tpls_on_draw_type", using: :btree
  add_index "card_tpls", ["indate_today"], name: "index_card_tpls_on_indate_today", using: :btree
  add_index "card_tpls", ["indate_type"], name: "index_card_tpls_on_indate_type", using: :btree
  add_index "card_tpls", ["member_id"], name: "index_card_tpls_on_member_id", using: :btree
  add_index "card_tpls", ["person_limit"], name: "index_card_tpls_on_person_limit", using: :btree
  add_index "card_tpls", ["public"], name: "index_card_tpls_on_public", using: :btree
  add_index "card_tpls", ["state"], name: "index_card_tpls_on_state", using: :btree
  add_index "card_tpls", ["total"], name: "index_card_tpls_on_total", using: :btree
  add_index "card_tpls", ["type"], name: "index_card_tpls_on_type", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "type",                limit: 10,  default: "", null: false
    t.integer  "card_tpl_id",         limit: 4
    t.string   "code",                limit: 255
    t.string   "state",               limit: 10,  default: "", null: false
    t.datetime "deleted_at"
    t.integer  "locked_by_id",        limit: 4
    t.integer  "locked_by_tpl_id",    limit: 4
    t.integer  "locked_tpl_id",       limit: 4
    t.integer  "locked_id",           limit: 4
    t.string   "phone",               limit: 20,  default: "", null: false
    t.datetime "acquired_at"
    t.datetime "checked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "added_quantity_id",   limit: 4
    t.integer  "removed_quantity_id", limit: 4
    t.integer  "client_id",           limit: 4
    t.string   "capcha",              limit: 10,  default: ""
    t.datetime "from"
    t.datetime "to"
    t.string   "checker_phone",       limit: 11
    t.string   "sender_phone",        limit: 11
    t.time     "acquired_time"
  end

  add_index "cards", ["added_quantity_id"], name: "index_cards_on_added_quantity_id", using: :btree
  add_index "cards", ["card_tpl_id"], name: "index_cards_on_card_tpl_id", using: :btree
  add_index "cards", ["checker_phone"], name: "index_cards_on_checker_phone", using: :btree
  add_index "cards", ["client_id"], name: "index_cards_on_client_id", using: :btree
  add_index "cards", ["code"], name: "index_cards_on_code", unique: true, using: :btree
  add_index "cards", ["deleted_at"], name: "index_cards_on_deleted_at", using: :btree
  add_index "cards", ["from"], name: "index_cards_on_from", using: :btree
  add_index "cards", ["locked_by_id"], name: "index_cards_on_locked_by_id", using: :btree
  add_index "cards", ["locked_by_tpl_id"], name: "index_cards_on_locked_by_tpl_id", using: :btree
  add_index "cards", ["locked_id"], name: "index_cards_on_locked_id", using: :btree
  add_index "cards", ["locked_tpl_id"], name: "index_cards_on_locked_tpl_id", using: :btree
  add_index "cards", ["phone"], name: "index_cards_on_phone", using: :btree
  add_index "cards", ["removed_quantity_id"], name: "index_cards_on_removed_quantity_id", using: :btree
  add_index "cards", ["sender_phone"], name: "index_cards_on_sender_phone", using: :btree
  add_index "cards", ["state"], name: "index_cards_on_state", using: :btree
  add_index "cards", ["to"], name: "index_cards_on_to", using: :btree
  add_index "cards", ["type"], name: "index_cards_on_type", using: :btree

  create_table "client_managers", force: :cascade do |t|
    t.integer  "client_id",  limit: 4
    t.integer  "member_id",  limit: 4
    t.boolean  "sender"
    t.boolean  "admin"
    t.boolean  "checker"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "phone",      limit: 255
    t.string   "name",       limit: 255
    t.integer  "shop_id",    limit: 4
  end

  add_index "client_managers", ["admin"], name: "index_client_managers_on_admin", using: :btree
  add_index "client_managers", ["checker"], name: "index_client_managers_on_checker", using: :btree
  add_index "client_managers", ["client_id"], name: "index_client_managers_on_client_id", using: :btree
  add_index "client_managers", ["member_id"], name: "index_client_managers_on_member_id", using: :btree
  add_index "client_managers", ["phone"], name: "index_client_managers_on_phone", using: :btree
  add_index "client_managers", ["sender"], name: "index_client_managers_on_sender", using: :btree
  add_index "client_managers", ["shop_id"], name: "index_client_managers_on_shop_id", using: :btree

  create_table "client_members", force: :cascade do |t|
    t.integer  "client_id",        limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "name",             limit: 255
    t.string   "sex",              limit: 255
    t.date     "borned_at"
    t.string   "address",          limit: 255
    t.string   "email",            limit: 255
    t.string   "pic_file_name",    limit: 255
    t.string   "pic_content_type", limit: 255
    t.integer  "pic_file_size",    limit: 4
    t.datetime "pic_updated_at"
    t.string   "phone",            limit: 255
    t.float    "money",            limit: 24,  default: 0.0, null: false
  end

  add_index "client_members", ["phone", "client_id"], name: "index_client_members_on_phone_and_client_id", unique: true, using: :btree

  create_table "client_settings", force: :cascade do |t|
    t.integer  "client_id",      limit: 4
    t.boolean  "show_name"
    t.boolean  "show_phone"
    t.boolean  "show_borned_at"
    t.boolean  "show_pic"
    t.boolean  "show_address"
    t.boolean  "show_email"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "client_settings", ["client_id"], name: "index_client_settings_on_client_id", using: :btree
  add_index "client_settings", ["show_address"], name: "index_client_settings_on_show_address", using: :btree
  add_index "client_settings", ["show_borned_at"], name: "index_client_settings_on_show_borned_at", using: :btree
  add_index "client_settings", ["show_email"], name: "index_client_settings_on_show_email", using: :btree
  add_index "client_settings", ["show_name"], name: "index_client_settings_on_show_name", using: :btree
  add_index "client_settings", ["show_phone"], name: "index_client_settings_on_show_phone", using: :btree
  add_index "client_settings", ["show_pic"], name: "index_client_settings_on_show_pic", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.string   "reg",                      limit: 255
    t.string   "address",                  limit: 255
    t.string   "position",                 limit: 255
    t.float    "location_y",               limit: 24
    t.float    "localtion_x",              limit: 24
    t.string   "phone",                    limit: 255
    t.string   "area",                     limit: 255
    t.string   "type",                     limit: 255
    t.date     "service_started"
    t.date     "service_ended_at"
    t.string   "website",                  limit: 255
    t.string   "wechat_account",           limit: 255
    t.string   "wechat_title",             limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "logo_file_name",           limit: 255
    t.string   "logo_content_type",        limit: 255
    t.integer  "logo_file_size",           limit: 4
    t.datetime "logo_updated_at"
    t.string   "wechat_logo_file_name",    limit: 255
    t.string   "wechat_logo_content_type", limit: 255
    t.integer  "wechat_logo_file_size",    limit: 4
    t.datetime "wechat_logo_updated_at"
    t.string   "admin_phone",              limit: 255
    t.boolean  "is_sp"
    t.integer  "sp_id",                    limit: 4
    t.boolean  "show_name"
    t.boolean  "show_phone"
    t.boolean  "show_sex"
    t.boolean  "show_borned_at"
    t.boolean  "show_pic"
    t.boolean  "show_address"
    t.boolean  "show_email"
  end

  add_index "clients", ["is_sp"], name: "index_clients_on_is_sp", using: :btree
  add_index "clients", ["sp_id"], name: "index_clients_on_sp_id", using: :btree

  create_table "draw_awards", force: :cascade do |t|
    t.integer  "card_tpl_id", limit: 4
    t.string   "title",       limit: 255
    t.integer  "award_id",    limit: 4
    t.integer  "number",      limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "draw_awards", ["award_id"], name: "index_draw_awards_on_award_id", using: :btree
  add_index "draw_awards", ["card_tpl_id"], name: "index_draw_awards_on_card_tpl_id", using: :btree

  create_table "files", force: :cascade do |t|
    t.integer  "file_owner_id",     limit: 4
    t.string   "file_owner_type",   limit: 255
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.string   "type",              limit: 255
  end

  add_index "files", ["file_owner_id", "file_owner_type"], name: "index_files_on_file_owner_id_and_file_owner_type", using: :btree

  create_table "gabe_dayus", force: :cascade do |t|
    t.string   "smsType",         limit: 255, default: "",    null: false
    t.string   "smsFreeSignName", limit: 255, default: "",    null: false
    t.string   "smsParam",        limit: 255, default: "",    null: false
    t.string   "recNum",          limit: 255, default: "",    null: false
    t.string   "smsTemplateCode", limit: 255, default: "",    null: false
    t.string   "appkey",          limit: 255,                 null: false
    t.integer  "dayuable_id",     limit: 4,                   null: false
    t.string   "dayuable_type",   limit: 255,                 null: false
    t.string   "result",          limit: 255, default: "",    null: false
    t.datetime "sended_at"
    t.boolean  "sended",                      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",            limit: 255
  end

  add_index "gabe_dayus", ["appkey"], name: "gabe_dayus_appkey_index", using: :btree
  add_index "gabe_dayus", ["dayuable_id"], name: "gabe_dayus_dayuable_id_index", using: :btree
  add_index "gabe_dayus", ["dayuable_type", "dayuable_id"], name: "gabe_dayus_dayuable_type_dayuable_id_index", using: :btree
  add_index "gabe_dayus", ["dayuable_type"], name: "gabe_dayus_dayuable_type_index", using: :btree
  add_index "gabe_dayus", ["recNum"], name: "gabe_dayus_recnum_index", using: :btree
  add_index "gabe_dayus", ["sended"], name: "gabe_dayus_sended_index", using: :btree
  add_index "gabe_dayus", ["smsFreeSignName"], name: "gabe_dayus_smsfreesignname_index", using: :btree
  add_index "gabe_dayus", ["smsTemplateCode"], name: "gabe_dayus_smstemplatecode_index", using: :btree
  add_index "gabe_dayus", ["smsType"], name: "gabe_dayus_smstype_index", using: :btree
  add_index "gabe_dayus", ["type"], name: "index_gabe_dayus_on_type", using: :btree

  create_table "get_periods", force: :cascade do |t|
    t.integer  "card_tpl_id",  limit: 4
    t.string   "from",         limit: 255
    t.string   "to",           limit: 255
    t.integer  "number",       limit: 4
    t.integer  "person_limit", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "get_periods", ["card_tpl_id"], name: "index_get_periods_on_card_tpl_id", using: :btree

  create_table "group_members", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.integer  "member_id",  limit: 4
    t.date     "started_at"
    t.date     "ended_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "phone",      limit: 255
    t.integer  "client_id",  limit: 4
  end

  add_index "group_members", ["client_id"], name: "index_group_members_on_client_id", using: :btree
  add_index "group_members", ["group_id"], name: "index_group_members_on_group_id", using: :btree
  add_index "group_members", ["member_id"], name: "index_group_members_on_member_id", using: :btree
  add_index "group_members", ["phone", "group_id"], name: "index_group_members_on_phone_and_group_id", unique: true, using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "client_id",  limit: 4
    t.string   "title",      limit: 255,   default: ""
    t.integer  "position",   limit: 4,     default: 0
    t.string   "desc",       limit: 10000, default: ""
    t.boolean  "active",                   default: true
    t.boolean  "default",                  default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "groups", ["active"], name: "index_groups_on_active", using: :btree
  add_index "groups", ["client_id", "title"], name: "index_groups_on_client_id_and_title", unique: true, using: :btree
  add_index "groups", ["client_id"], name: "index_groups_on_client_id", using: :btree
  add_index "groups", ["default"], name: "index_groups_on_default", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id",      limit: 4
    t.string   "imageable_type",    limit: 255
    t.string   "phone",             limit: 15
    t.integer  "client_id",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
  end

  add_index "images", ["client_id"], name: "index_images_on_client_id", using: :btree
  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree
  add_index "images", ["phone"], name: "index_images_on_phone", using: :btree

  create_table "imports", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.integer  "importable_id",     limit: 4
    t.string   "importable_type",   limit: 255
    t.string   "type",              limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "client_id",         limit: 4
    t.integer  "group_id",          limit: 4
  end

  add_index "imports", ["client_id"], name: "index_imports_on_client_id", using: :btree
  add_index "imports", ["group_id"], name: "index_imports_on_group_id", using: :btree
  add_index "imports", ["importable_id"], name: "index_imports_on_importable_id", using: :btree
  add_index "imports", ["importable_type"], name: "index_imports_on_importable_type", using: :btree
  add_index "imports", ["type"], name: "index_imports_on_type", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "email",                   limit: 255, default: "", null: false
    t.string   "encrypted_password",      limit: 255, default: "", null: false
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",      limit: 255
    t.string   "last_sign_in_ip",         limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "username",                limit: 255
    t.string   "phone",                   limit: 255
    t.boolean  "wechat_binded"
    t.string   "remember_token",          limit: 255
    t.string   "capcha",                  limit: 255
    t.string   "recover_password_capcha", limit: 10
    t.string   "update_password_capcha",  limit: 10
    t.string   "bind_wechat_capcha",      limit: 10
    t.datetime "capcha_expired_at"
  end

  add_index "members", ["capcha"], name: "index_members_on_capcha", using: :btree
  add_index "members", ["phone"], name: "index_members_on_phone", unique: true, using: :btree
  add_index "members", ["remember_token"], name: "index_members_on_remember_token", using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  add_index "members", ["username"], name: "index_members_on_username", unique: true, using: :btree
  add_index "members", ["wechat_binded"], name: "index_members_on_wechat_binded", using: :btree

  create_table "migrations", id: false, force: :cascade do |t|
    t.string  "migration", limit: 255, null: false
    t.integer "batch",     limit: 4,   null: false
  end

  create_table "mobile_files", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.string   "type",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
  end

  add_index "mobile_files", ["type"], name: "index_mobile_files_on_type", using: :btree
  add_index "mobile_files", ["user_id"], name: "index_mobile_files_on_user_id", using: :btree

  create_table "moneys", force: :cascade do |t|
    t.integer  "member_id",        limit: 4
    t.integer  "client_id",        limit: 4
    t.integer  "client_member_id", limit: 4
    t.float    "money",            limit: 24
    t.integer  "spendable_id",     limit: 4
    t.string   "spendable_type",   limit: 255
    t.string   "by_phone",         limit: 20
    t.string   "type",             limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "moneys", ["by_phone"], name: "index_moneys_on_by_phone", using: :btree
  add_index "moneys", ["client_id"], name: "index_moneys_on_client_id", using: :btree
  add_index "moneys", ["client_member_id"], name: "index_moneys_on_client_member_id", using: :btree
  add_index "moneys", ["member_id"], name: "index_moneys_on_member_id", using: :btree
  add_index "moneys", ["money"], name: "index_moneys_on_money", using: :btree
  add_index "moneys", ["spendable_id"], name: "index_moneys_on_spendable_id", using: :btree
  add_index "moneys", ["spendable_type"], name: "index_moneys_on_spendable_type", using: :btree
  add_index "moneys", ["type"], name: "index_moneys_on_type", using: :btree

  create_table "password_resets", id: false, force: :cascade do |t|
    t.string   "email",      limit: 255, null: false
    t.string   "token",      limit: 255, null: false
    t.datetime "created_at",             null: false
  end

  add_index "password_resets", ["email"], name: "password_resets_email_index", using: :btree
  add_index "password_resets", ["token"], name: "password_resets_token_index", using: :btree

  create_table "periods", force: :cascade do |t|
    t.integer  "card_tpl_id",  limit: 4
    t.time     "from"
    t.time     "to"
    t.integer  "number",       limit: 4
    t.string   "type",         limit: 255
    t.integer  "person_limit", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "periods", ["card_tpl_id"], name: "index_periods_on_card_tpl_id", using: :btree
  add_index "periods", ["from"], name: "index_periods_on_from", using: :btree
  add_index "periods", ["to"], name: "index_periods_on_to", using: :btree
  add_index "periods", ["type"], name: "index_periods_on_type", using: :btree

  create_table "quantities", force: :cascade do |t|
    t.integer  "number",      limit: 4
    t.integer  "card_tpl_id", limit: 4
    t.integer  "member_id",   limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "quantities", ["card_tpl_id"], name: "index_quantities_on_card_tpl_id", using: :btree
  add_index "quantities", ["member_id"], name: "index_quantities_on_member_id", using: :btree
  add_index "quantities", ["number"], name: "index_quantities_on_number", using: :btree

  create_table "shops", force: :cascade do |t|
    t.integer  "client_id",  limit: 4
    t.string   "title",      limit: 255
    t.string   "address",    limit: 255
    t.string   "phone",      limit: 255
    t.float    "x",          limit: 24
    t.float    "y",          limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "shops", ["client_id"], name: "index_shops_on_client_id", using: :btree

  create_table "spends", force: :cascade do |t|
    t.integer  "member_id",        limit: 4
    t.integer  "client_id",        limit: 4
    t.integer  "client_member_id", limit: 4
    t.float    "money",            limit: 24
    t.integer  "spendable_id",     limit: 4
    t.string   "spendable_type",   limit: 255
    t.integer  "by_member_id",     limit: 4
    t.string   "type",             limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "spends", ["by_member_id"], name: "index_spends_on_by_member_id", using: :btree
  add_index "spends", ["client_id"], name: "index_spends_on_client_id", using: :btree
  add_index "spends", ["client_member_id"], name: "index_spends_on_client_member_id", using: :btree
  add_index "spends", ["member_id"], name: "index_spends_on_member_id", using: :btree
  add_index "spends", ["spendable_id"], name: "index_spends_on_spendable_id", using: :btree
  add_index "spends", ["spendable_type"], name: "index_spends_on_spendable_type", using: :btree
  add_index "spends", ["type"], name: "index_spends_on_type", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.string   "email",          limit: 255, null: false
    t.string   "password",       limit: 255, null: false
    t.string   "remember_token", limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "users_email_unique", unique: true, using: :btree

end
