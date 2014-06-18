class AddPlaceToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :place, :string
  end
end
