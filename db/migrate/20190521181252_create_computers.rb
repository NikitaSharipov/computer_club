class CreateComputers < ActiveRecord::Migration[5.2]
  def change
    create_table :computers do |t|
      t.string :title, null: false
      t.text :specifications
      t.integer :cost, null: false
      t.datetime :creation, null: false
    end
  end
end
