Spree::Order.class_eval do

  def get_line_items
    spree_line_items = []
    line_items_and_variants.map do |line_item|
      new_line_item = {
          price_data: {
              currency: self.currency,
              product_data: {
                  name: line_item.variant.name
              },
              unit_amount: (line_item.total.to_f * 100).to_i
          },
          quantity: line_item.quantity
      }
      spree_line_items.push(new_line_item)
    end
    spree_line_items.push(get_shipment_item(self.currency))
    spree_line_items
  end

  def get_shipment_item(currency)
    shipments = self.shipments
    if shipments.length <= 0
      return price_data(currency, "Shipment", 0, 1)
    else
      last_shipment = shipments.last
      return price_data(currency, "Shipment", (last_shipment.cost.to_f * 100).to_i, 1)
    end
  end


  def price_data(currency, name, unit_amount, quantity)
    {
        price_data: {
            currency: currency,
            product_data: {
                name: name
            },
            unit_amount: unit_amount
        },
        quantity: quantity
    }
  end

  def line_items_and_variants
    self.line_items.includes(:variant)
  end

  def force_complete(cs, payment_method, transaction_id, amount)
    source = Spree::CreditCard.new(gateway_customer_profile_id: cs)
    if source.save!
      new_payment = self.payments.new(response_code: transaction_id, amount: amount, source: source, payment_method: payment_method, state: "completed")
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
