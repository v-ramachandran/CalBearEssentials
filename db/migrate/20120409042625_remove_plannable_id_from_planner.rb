class RemovePlannableIdFromPlanner < ActiveRecord::Migration
  def up
    remove_column :planners, :plannable_id
  end

  def down
    add_column :planners, :plannable_id, :integer
  end
end
