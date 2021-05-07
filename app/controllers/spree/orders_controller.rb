class Spree::OrdersController < ::Spree::Api::V2::BaseController

  def get_order
    order = Spree::Order.find_by(number: params["order_id"])
    if order.nil?
      render json: {order: nil, status: :not_found}, status: :not_found
    else
      spree_order = order.attributes
      spree_order["user_name"] = order.name
      render json: {order: spree_order, status: :ok}, status: :ok
    end
  end

end