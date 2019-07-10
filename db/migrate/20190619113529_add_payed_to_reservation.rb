class AddPayedToReservation < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :payed, :boolean, default: false
  end
end
