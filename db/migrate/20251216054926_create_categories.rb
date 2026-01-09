class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: ""
      t.string :color, null: true

      t.timestamps
    end
  end
end
