class CreateChoreTasks < ActiveRecord::Migration
  def change
    create_table :chore_tasks do |t|
      t.integer :chore_id
      t.integer :task_id
    end
  end
end
