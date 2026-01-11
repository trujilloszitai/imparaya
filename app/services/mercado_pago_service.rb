class MercadoPagoService
  def self.create_preference(booking, user, back_urls)
      payer_email = Rails.env.production? ? user.email : "test_user@testuser.com"

    preference_data = {
        items: [
          {
            id: booking.id.to_s,
            title: "Clase con #{booking.availability.mentor.full_name} - #{booking.availability.category&.name}",
            description: "Clase el #{I18n.l(booking.starts_at, format: :short)}",
            quantity: 1,
            currency_id: "ARS",
            unit_price: booking.price.to_f
          }
        ],
        payer: {
          email: payer_email,
          name: "name_test",
          surname: "surname_test",
          identification: {
            type: "DNI",
            number: "12345678"
          }
        },
        payment_methods: {
          excluded_payment_types: [],
          excluded_payment_methods: [],
          installments: 12,
          default_installaments: 1
        },
        back_urls: back_urls,
        auto_return: "approved",
        external_reference: booking.id.to_s,
        notification_url: ENV["MP_WEBHOOK_URL"] ? ENV["MP_WEBHOOK_URL"] + "/webhooks/mercadopago" : nil
      }

    preference_response = $mp.preference.create(preference_data)
    preference_response
  end

  def self.get_payment_info(payment_id)
    $mp.payment.get(payment_id)
  end
end
