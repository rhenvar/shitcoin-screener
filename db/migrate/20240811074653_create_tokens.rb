# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :tokens do |t|
      t.string :address, null: false
      t.datetime :created

      t.boolean :rugged, default: false
      t.boolean :trust, default: false
      # Architect's note: It's possible to be a rugged trust. I know, weird right?
      # This is called getting ass-fucked in crypto and it happens. Deal with it

      t.timestamps
      t.index :address
    end
  end
end
