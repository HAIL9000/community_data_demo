# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2013_08_05_163630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pull_requests", id: :serial, force: :cascade do |t|
    t.integer "pull_request_number"
    t.string "repository_name"
    t.string "repository_owner"
    t.boolean "merged_status"
    t.datetime "time_opened"
    t.datetime "time_closed"
    t.boolean "from_community"
    t.boolean "closed"
  end

end
