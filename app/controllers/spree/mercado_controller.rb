class Spree::MercadoController < ::Spree::Api::V2::BaseController
  include Spree::Api::V2::Storefront::OrderConcern
  require 'mercadopago'
  before_action :ensure_order


  def checkout
    begin
      if spree_current_order
        if spree_current_order.line_items.length > 0
          sdk = Mercadopago::SDK.new('TEST-4069344879757400-052823-bb63e3f0bd945241bdcfb1a61be66a19-435312685')
          preference_data = {
              items: spree_current_order.get_line_items_mercado,
              shipments: spree_current_order.get_shipment_item_mercado,
              binary_mode: true,
              mode: "redirect",
              auto_return: "approved",
              back_urls: {
                  success: 'http://localhost:3000/cart/success',
                  failure: 'http://localhost:3000/cart',
                  pending: 'http://localhost:3000/cart',
              }
          }
          preference_response = sdk.preference.create(preference_data)
          preference = preference_response[:response]
          @preference_id = preference['init_point']
          puts "#{preference}"
          return render json: {id: @preference_id, error: nil}
        else
          return render json: {id: nil, error: "Invalid order"}
        end
      else
        return render json: {id: nil, error: "Invalid order"}
      end
    rescue => e
      return render json: {id: nil, error: e}
    end
  end


end