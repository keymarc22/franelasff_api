# frozen_string_literal: true

class CreateShirts < ActiveRecord::Migration[6.1]
  def change
    create_table :shirts do |t|
      t.string :code
      t.string :color
      t.string :print
      t.integer :quantity
      t.text :aditional_description

      t.timestamps
    end
  end
end
