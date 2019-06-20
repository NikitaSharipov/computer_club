class AddCreditsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :credits, :integer, default: 0
  end
end
