class AddStartAtToVillages < ActiveRecord::Migration[5.2]
  def change
    add_column :villages, :start_at, :datetime
  end
end
