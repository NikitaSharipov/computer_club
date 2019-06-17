class CreateSoftwareRequest < ActiveRecord::Migration[5.2]
  def change
    create_table :software_requests do |t|
      t.references :computer, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.text :description
      t.boolean :completed
    end
  end
end
