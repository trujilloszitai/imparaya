class AddDeletedAtToAvailability < ActiveRecord::Migration[8.1]
  def change
    add_column :availabilities, :deleted_at, :datetime
    add_index :availabilities, :deleted_at
  end
end
