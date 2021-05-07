module Spree
  class Gateway::Mercadopago < Spree::Gateway::StripeGateway

    def method_type
      'mercadopago'
    end

    def provider_class
      ActiveMerchant::Billing::StripeGateway
    end
  end
end