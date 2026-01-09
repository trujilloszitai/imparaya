require "mercadopago"

$mp = Mercadopago::SDK.new(Rails.application.credentials.dig(:mercadopago, :access_token))
