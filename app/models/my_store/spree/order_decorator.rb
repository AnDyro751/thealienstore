Spree::Order.class_eval do

  def force_complete(cs, payment_method, transaction_id)
    source = Spree::CreditCard.new(gateway_customer_profile_id: cs)
    if source.save!
      new_payment = self.payments.new(response_code: transaction_id,amount: self.total, source: source, payment_method: payment_method, state: "completed")
      if new_payment.save!
        self.update(state: "complete")
        self.finalize!
      else
        raise "Invalid payment"
      end
    else
      raise "Invalid source"
    end
  end

end

# ::Spree::Product.prepend MyStore::Spree::ProductDecorator if ::Spree::Product.included_modules.exclude?(MyStore::Spree::ProductDecorator)
