class CreateSatisfieds < ActiveRecord::Migration
  def change
    create_table :satisfieds do |t|
      t.integer :degree_id
      t.integer :requirement_id
      t.integer :units
      t.integer :times

      t.timestamps
    end
  end
end
