# frozen_string_literal: true

class AddReferenceStoreToShirt < ActiveRecord::Migration[6.1]
  def change
    add_reference :shirts, :store, index: true
  end
end
