# frozen_string_literal: true

class AddOwnerToShirt < ActiveRecord::Migration[6.1]
  def change
    add_reference :shirts, :owner, polymorphic: true, null: true
  end
end
