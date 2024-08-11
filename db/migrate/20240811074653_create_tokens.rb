# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :tokens do |t|
      t.string :address, null: false
      t.datetime :release_date, null: false
      t.boolean :rug, default: false
      t.boolean :liquidity_locked, default: false

      t.timestamps
    end
  end
end
