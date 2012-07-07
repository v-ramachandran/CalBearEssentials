class AddTypeToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :type, :string
  end
end
