# frozen_string_literal: true

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

ActiveRecord::Schema[7.2].define(version: 20_240_811_074_653) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'tokens', force: :cascade do |t|
    t.string 'address', null: false
    t.datetime 'pair_create_date', null: false
    t.string 'network', default: 'ethereum', null: false
    t.boolean 'rugged', default: false
    t.boolean 'adequate_liquidity', default: false
    t.boolean 'adequate_market_cap', default: false
    t.boolean 'adequate_transaction_count', default: false
    t.boolean 'liquidity_locked', default: false
    t.boolean 'honeypot', default: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
