class Spree::WebhooksController < ::Spree::Api::V2::BaseController
  include Spree::Api::V2::Storefront::OrderConcern
  Stripe.api_key = "sk_test_51IX9BNFtFW4yYd5sRXGhqetBFvbvy0ImFAyujffa2KNV6zTRMBfJkPJ4cIcfkWNvE5CfnbPEvdwaBWNxFslPpTBL00GhP2vjLm"


  def checkout
    endpoint_secret = "whsec_zGzU8dkLTBKuQWYYBy8VEv3YSPPgcB1i"
    begin
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      payload = request.body.read
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      return status 400
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      return status 400
    end


    payload = request.body.read
    if event['type'] == 'checkout.session.completed'
      checkout_session = event['data']['object']
      return status 400 if checkout_session.payment_status != "paid"

      metadata_number = checkout_session["metadata"]["order_number"]
      spree_order = Spree::Order.find_by(number: metadata_number)
      return status 400 if spree_order.nil?
      spree_order.force_complete(
          checkout_session["id"],
          Spree::PaymentMethod.find_by(type: "Spree::Gateway::StripeElementsGateway"),
          checkout_session["payment_intent"],
          checkout_session["amount_total"])
      puts "-----------#{checkout_session}"
      # fulfill_order(checkout_session)
    end
    puts "#{payload.inspect}------------------#{event["type"]}"
    render status: 200, json: {success: true}
  end

end
