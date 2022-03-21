# frozen_string_literal: true

class AddIndexToCodeShirt < ActiveRecord::Migration[6.1]
  def change
    add_index :shirts, :code, unique: true
  end
end
