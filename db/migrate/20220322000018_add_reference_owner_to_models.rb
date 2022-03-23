# frozen_string_literal: true

class AddReferenceOwnerToModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :shirts, :owner, index: true
    add_reference :catalogues, :owner, index: true
    add_reference :stores, :owner, index: true
  end
end
