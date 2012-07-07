class CreateTaughts < ActiveRecord::Migration
  def change
    create_table :taughts do |t|
      t.integer :professor_id
      t.integer :course_id

      t.timestamps
    end
  end
end
