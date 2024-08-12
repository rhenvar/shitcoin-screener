# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :tokens do |t|
      t.string :address, null: false
      t.datetime :pair_create_date, null: false
      t.string :network, null: false, default: 'ethereum'

      t.boolean :rugged, default: false
      t.boolean :adequate_liquidity, default: false
      t.boolean :adequate_market_cap, default: false
      t.boolean :adequate_transaction_count, default: false
      t.boolean :liquidity_locked, default: false
      t.boolean :honeypot, default: true

      t.timestamps
    end
  end
end
