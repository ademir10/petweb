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

ActiveRecord::Schema.define(version: 20160520193535) do

  create_table "cidades", force: :cascade do |t|
    t.string   "nome"
    t.integer  "estado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cidades", ["estado_id"], name: "index_cidades_on_estado_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "company"
    t.string   "name"
    t.string   "address"
    t.string   "neighborhood"
    t.integer  "cidade_id"
    t.integer  "estado_id"
    t.string   "cep"
    t.string   "phone"
    t.string   "cellphone"
    t.string   "email"
    t.string   "cnpj"
    t.string   "nf"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "clients", ["cidade_id"], name: "index_clients_on_cidade_id", using: :btree
  add_index "clients", ["estado_id"], name: "index_clients_on_estado_id", using: :btree

  create_table "estados", force: :cascade do |t|
    t.string   "sigla"
    t.string   "nome"
    t.integer  "capital_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "estados", ["capital_id"], name: "index_estados_on_capital_id", using: :btree

  create_table "expire_dates", force: :cascade do |t|
    t.date     "date_expire"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "intowels", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "form_receipt"
    t.integer  "installments"
    t.string   "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "intowels", ["client_id"], name: "index_intowels_on_client_id", using: :btree

  create_table "itemouts", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "qnt"
    t.integer  "outtowel_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "itemouts", ["outtowel_id"], name: "index_itemouts_on_outtowel_id", using: :btree
  add_index "itemouts", ["product_id"], name: "index_itemouts_on_product_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "qnt"
    t.decimal  "sale_value"
    t.decimal  "total_value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "intowel_id"
  end

  add_index "items", ["intowel_id"], name: "index_items_on_intowel_id", using: :btree
  add_index "items", ["product_id"], name: "index_items_on_product_id", using: :btree

  create_table "loginfos", force: :cascade do |t|
    t.string   "employee"
    t.string   "task"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outtowels", force: :cascade do |t|
    t.integer  "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
  end

  add_index "outtowels", ["client_id"], name: "index_outtowels_on_client_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.string   "doc_number"
    t.string   "description"
    t.date     "due_date"
    t.date     "payment_date"
    t.integer  "installments"
    t.decimal  "value_doc"
    t.string   "type_doc"
    t.string   "form_payment"
    t.string   "status"
    t.integer  "supplier_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "payments", ["supplier_id"], name: "index_payments_on_supplier_id", using: :btree

  create_table "prod_clis", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "product_id"
    t.integer  "qnt"
    t.decimal  "val1"
    t.decimal  "val2"
    t.decimal  "val3"
    t.decimal  "val4"
    t.decimal  "val5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "prod_clis", ["client_id"], name: "index_prod_clis_on_client_id", using: :btree
  add_index "prod_clis", ["product_id"], name: "index_prod_clis_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.string   "doc_number"
    t.string   "type_doc"
    t.integer  "client_id"
    t.string   "description"
    t.date     "due_date"
    t.date     "receipt_date"
    t.integer  "installments"
    t.string   "form_receipt"
    t.string   "status"
    t.integer  "intowel_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.decimal  "value_doc"
  end

  add_index "receipts", ["client_id"], name: "index_receipts_on_client_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "company"
    t.string   "name"
    t.string   "address"
    t.string   "neighborhood"
    t.integer  "cidade_id"
    t.integer  "estado_id"
    t.string   "cep"
    t.string   "phone"
    t.string   "cellphone"
    t.string   "email"
    t.string   "cnpj"
    t.string   "bank"
    t.string   "agency"
    t.string   "acount"
    t.string   "favored"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "suppliers", ["cidade_id"], name: "index_suppliers_on_cidade_id", using: :btree
  add_index "suppliers", ["estado_id"], name: "index_suppliers_on_estado_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "type_access"
    t.boolean  "ccli"
    t.boolean  "csuplier"
    t.boolean  "cprod"
    t.boolean  "cuser"
    t.boolean  "min"
    t.boolean  "mout"
    t.boolean  "mlog"
    t.boolean  "fpag"
    t.boolean  "frec"
    t.boolean  "rcli"
    t.boolean  "rsuplier"
    t.boolean  "rprod"
    t.boolean  "rpag"
    t.boolean  "rrec"
    t.boolean  "rsale"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "macerto"
  end

  add_foreign_key "clients", "cidades"
  add_foreign_key "clients", "estados"
  add_foreign_key "intowels", "clients"
  add_foreign_key "itemouts", "outtowels"
  add_foreign_key "itemouts", "products"
  add_foreign_key "items", "intowels"
  add_foreign_key "items", "products"
  add_foreign_key "outtowels", "clients"
  add_foreign_key "payments", "suppliers"
  add_foreign_key "prod_clis", "clients"
  add_foreign_key "prod_clis", "products"
  add_foreign_key "receipts", "clients"
  add_foreign_key "suppliers", "cidades"
  add_foreign_key "suppliers", "estados"
end
