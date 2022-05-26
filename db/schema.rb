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

ActiveRecord::Schema.define(version: 2022_05_26_070157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guides", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "patient_id", null: false
    t.string "value"
    t.string "detail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["patient_id"], name: "index_guides_on_patient_id"
    t.index ["provider_id"], name: "index_guides_on_provider_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "cpf"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cpf"], name: "index_patients_on_cpf"
  end

  create_table "procedures", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "profile"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "guide_id"
    t.index ["code"], name: "index_procedures_on_code"
    t.index ["guide_id"], name: "index_procedures_on_guide_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_providers_on_code"
  end

  add_foreign_key "guides", "patients"
  add_foreign_key "guides", "providers"
  add_foreign_key "procedures", "guides"
end
