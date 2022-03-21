# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :location

      t.timestamps
    end
  end
end
