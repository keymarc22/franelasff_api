class AddReferenceOwnerToModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :shirts, :user, index: true
    add_reference :catalogues, :user, index: true
    add_reference :stores, :user, index: true
  end
end
