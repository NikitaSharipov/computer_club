class AddLastServicaAndServiceFrequencyToComputer < ActiveRecord::Migration[5.2]
  def change
    add_column :computers, :last_service, :datetime
    add_column :computers, :service_frequency, :integer, default: 9
    add_column :computers, :service_needed, :boolean, default: false
  end
end
