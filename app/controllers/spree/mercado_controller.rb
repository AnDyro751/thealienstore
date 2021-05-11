class Spree::StripeController < ::Spree::Api::V2::BaseController
  include Spree::Api::V2::Storefront::OrderConcern
  before_action :ensure_order

  sdk = Mercadopago::SDK.new('TEST-4069344879757400-052823-bb63e3f0bd945241bdcfb1a61be66a19-435312685')

  def checkout
    preference_data = {
        items: [
            {
                title: 'Mi producto',
                unit_price: 75.56,
                quantity: 1
            }
        ]
    }

    preference_response = sdk.preference.create(preference_data)
    preference = preference_response[:response]
    @preference_id = preference['id']
    render json: {id: @preference_id}
  end


end