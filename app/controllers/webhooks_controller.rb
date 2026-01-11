class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :mercadopago ]

  def mercadopago
    if params[:type] == "payment"
      payment_id = params.dig(:data, :id)

      payment_info = MercadoPagoService.get_payment_info(payment_id)

      if payment_info["status"] == 200
        payment_data = payment_info["response"]
        booking = Booking.find_by(id: payment_data["external_reference"])

        if booking
          payment = Payment.find_or_initialize_by(mp_payment_id: payment_data["id"])
          payment.update(
            booking: booking,
            status: payment_data["status"],
            status_detail: payment_data["status_detail"],
            payment_method_id: payment_data["payment_method_id"],
            transaction_amount: payment_data["transaction_amount"],
            net_received_amount: payment_data["transaction_details"]["net_received_amount"],
            external_reference: payment_data["external_reference"],
            payer_email: payment_data["payer"]["email"]
          )

          case payment_data["status"]
          when "approved"
            booking.update(status: :paid)
          when "rejected"
            booking.update(status: :rejected)
          when "cancelled"
            booking.update(status: :cancelled)
          end
        end
      end
    end

    head :ok
  end
end
