class RemovePriorityFromTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :priority, :integer
  end
end
