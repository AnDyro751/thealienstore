class CurrencyController < ::Spree::Api::V2::BaseController
  include Spree::Api::V2::Storefront::OrderConcern
  before_action :ensure_order

  def change
    new_currency = params[:switch_to_currency]&.upcase
    if new_currency.present? && supported_currency?(new_currency)
      spree_current_order&.update(currency: new_currency)
    end
    return render json: { ok: "" }
  end
end
