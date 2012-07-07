class AddUnitsToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :units, :integer
  end
end
