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

ActiveRecord::Schema.define(version: 2022_06_08_174226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.string "contract_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_contracts_on_provider_id"
  end

  create_table "contracts_prices", id: false, force: :cascade do |t|
    t.bigint "price_id", null: false
    t.bigint "contract_id", null: false
    t.index ["contract_id"], name: "index_contracts_prices_on_contract_id"
    t.index ["price_id"], name: "index_contracts_prices_on_price_id"
  end

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

  create_table "guides_procedures", id: false, force: :cascade do |t|
    t.bigint "procedure_id", null: false
    t.bigint "guide_id", null: false
    t.index ["guide_id"], name: "index_guides_procedures_on_guide_id"
    t.index ["procedure_id"], name: "index_guides_procedures_on_procedure_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "cpf"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cpf"], name: "index_patients_on_cpf"
  end

  create_table "prices", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_prices_on_name"
  end

  create_table "procedures", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "profile"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_procedures_on_code"
  end

  create_table "providers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_providers_on_code"
  end

  add_foreign_key "contracts", "providers"
  add_foreign_key "guides", "patients"
  add_foreign_key "guides", "providers"
end
