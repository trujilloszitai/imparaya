class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :mp_payment_id, index: true
      t.string :status
      t.string :status_detail
      t.string :payment_method_id
      t.decimal :transaction_amount, precision: 10, scale: 2
      t.decimal :net_received_amount, precision: 10, scale: 2
      t.string :external_reference
      t.string :payer_email

      t.timestamps
    end
  end
end
