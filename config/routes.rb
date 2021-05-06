Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: "/"
  Spree::Core::Engine.add_routes do
    post "/stripe_checkout", to: "stripe#checkout"
    post "/webhooks", to: "webhooks#checkout"
  end
  get "/change_currency", to: "currency#change"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
