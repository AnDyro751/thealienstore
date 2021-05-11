class Spree::MercadoController < ::Spree::Api::V2::BaseController
  include Spree::Api::V2::Storefront::OrderConcern
  require 'mercadopago'
  require 'httparty'
  before_action :ensure_order, only: [:checkout]

  def initialize
    @token = "TEST-4069344879757400-052823-bb63e3f0bd945241bdcfb1a61be66a19-435312685"
  end

  def complete
    current_order = Spree::Order.find_by(number: params[:order_number])
    return render json: {error: "Invalid order", success: false}, status: :unprocessable_entity if current_order.nil?
    response = HTTParty.get("https://api.mercadopago.com/v1/payments/#{params["payment_id"]}", {
        headers: {
            authorization: "Bearer #{@token}"
        }
    })
    puts response.body, response.code, response.message, response.headers.inspect
    if response.code === 200
      begin
        data = JSON.parse(response.body)
        current_order.force_complete(
            params["payment_id"],
            Spree::PaymentMethod.find_by(type: "Spree::Gateway::Mercadopago"),
            params["payment_id"],
            data["transaction_details"]["total_paid_amount"]
        )
        return render json: {error: nil, success: true, data: data}
      rescue => e
        return render json: {error: e.message, success: false}, status: :unprocessable_entity
      end
    else
      return render json: {error: "Invalid response", success: false}, status: :unprocessable_entity
    end
  end

  def checkout
    begin
      if spree_current_order
        if spree_current_order.line_items.length > 0
          sdk = Mercadopago::SDK.new(@token)
          preference_data = {
              items: spree_current_order.get_line_items_mercado,
              shipments: spree_current_order.get_shipment_item_mercado,
              binary_mode: true,
              mode: "redirect",
              auto_return: "approved",
              back_urls: {
                  success: "http://localhost:3000/cart/success?order_number=#{spree_current_order.number}",
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