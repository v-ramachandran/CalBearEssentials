class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :abb
      t.string :name
      t.string :department
      t.integer :units
      t.integer :weight

      t.timestamps
    end
  end
end
