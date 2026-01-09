class CreateAvailabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :availabilities do |t|
      t.integer :day_of_week, null: false
      t.time :starts_at, null: false
      t.time :ends_at, null: false
      t.decimal :price_per_hour, null: false, scale: 2, precision: 10
      t.integer :capacity
      t.references :mentor, null: false, foreign_key: { to_table: :users }
      t.references :category, null: false, foreign_key: true
      t.text :description
      t.timestamps
    end
  end
end
