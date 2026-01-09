class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :availability, null: false, foreign_key: true
      t.datetime :ends_at, null: false
      t.string :preference_id, index: true
      t.decimal :price, null: false, scale: 2, precision: 10
      t.datetime :starts_at, null: false
      t.integer :status, null: false, default: 0
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
