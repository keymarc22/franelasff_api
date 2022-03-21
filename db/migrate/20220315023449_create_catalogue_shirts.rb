# frozen_string_literal: true

class CreateCatalogueShirts < ActiveRecord::Migration[6.1]
  def change
    create_table :catalogue_shirts do |t|
      t.references :shirt, null: false, foreign_key: true
      t.references :catalogue, null: false, foreign_key: true

      t.timestamps
    end
  end
end
