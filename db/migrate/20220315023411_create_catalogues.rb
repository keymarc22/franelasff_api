# frozen_string_literal: true

class CreateCatalogues < ActiveRecord::Migration[6.1]
  def change
    create_table :catalogues do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
