# frozen_string_literal: true

class AddOwnerToCatalogue < ActiveRecord::Migration[6.1]
  def change
    add_reference :catalogues, :owner, polymorphic: true, null: true
  end
end
