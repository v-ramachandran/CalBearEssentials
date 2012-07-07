class CreateRequireds < ActiveRecord::Migration
  def change
    create_table :requireds do |t|
      t.integer :requirement_id
      t.integer :course_id

      t.timestamps
    end
  end
end
