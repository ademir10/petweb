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

ActiveRecord::Schema.define(version: 20160517210802) do

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
    t.decimal  "val1"
    t.decimal  "val2"
    t.decimal  "val3"
    t.decimal  "val4"
    t.decimal  "val5"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "qnt"
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

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.boolean  "mlog"
  end

  add_foreign_key "clients", "cidades"
  add_foreign_key "clients", "estados"
  add_foreign_key "suppliers", "cidades"
  add_foreign_key "suppliers", "estados"
end
