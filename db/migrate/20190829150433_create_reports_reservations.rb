class CreateReportsReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reports_reservations do |t|
      t.references :reservation, foreign_key: true
      t.references :report, foreign_key: true
    end
  end
end
