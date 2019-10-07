class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.integer :status
      t.integer :priority
      t.datetime :deadline

      t.timestamps
    end
  end
end
