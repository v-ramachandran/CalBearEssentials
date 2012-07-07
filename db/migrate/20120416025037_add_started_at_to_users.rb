class AddStartedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :started_at, :integer
  end
end
