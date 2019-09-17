class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :title, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :proceeds
      t.integer :rent_length
      t.integer :idle_length
      t.references :user, foreign_key: true
      t.string :kind, null: false
    end
  end
end
