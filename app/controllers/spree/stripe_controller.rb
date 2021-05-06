class Spree::StripeController < ::Spree::Api::V2::BaseController
  include Spree::Api::V2::Storefront::OrderConcern
  before_action :ensure_order
  Stripe.api_key = "sk_test_51IX9BNFtFW4yYd5sRXGhqetBFvbvy0ImFAyujffa2KNV6zTRMBfJkPJ4cIcfkWNvE5CfnbPEvdwaBWNxFslPpTBL00GhP2vjLm"

  def checkout
    if spree_current_order
      session = Stripe::Checkout::Session.create({
                                                     customer_email: spree_current_order.email,
                                                     payment_method_types: ['card'],
                                                     line_items: [{
                                                                      price_data: {
                                                                          currency: 'usd',
                                                                          product_data: {
                                                                              name: 'T-shirt',
                                                                          },
                                                                          unit_amount: 2000,
                                                                      },
                                                                      quantity: 1,
                                                                  }],
                                                     mode: 'payment',
                                                     metadata: {
                                                         order_number: spree_current_order.number,
                                                         token: spree_current_order.token,
                                                         payment_method: "Spree::Gateway::StripeElementsGateway"
                                                     },
                                                     # These placeholder URLs will be replaced in a following step.
                                                     success_url: "http://localhost:3000/cart/success?order_number=#{spree_current_order.number}&session_id={CHECKOUT_SESSION_ID}",
                                                     cancel_url: 'http://localhost:3000/cart',
                                                 })
      render json: {id: session.id}
    else
      render json: {ok: ""}
    end
  end
end
  