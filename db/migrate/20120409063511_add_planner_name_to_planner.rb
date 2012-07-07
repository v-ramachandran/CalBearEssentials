class AddPlannerNameToPlanner < ActiveRecord::Migration
  def change
    add_column :planners, :planner_name, :string
  end
end
