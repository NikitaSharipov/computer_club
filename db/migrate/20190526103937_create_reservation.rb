class CreateReservation < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references :computer, foreign_key: true
      t.references :user, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
    end
  end
end
