# frozen_string_literal: true

class AddOwnerToStore < ActiveRecord::Migration[6.1]
  def change
    add_reference :stores, :owner, polymorphic: true, null: true
  end
end
