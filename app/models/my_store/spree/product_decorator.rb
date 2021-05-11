Spree::Product.class_eval do
  include AlgoliaSearch
  algoliasearch index_name: "products" do
    attribute :slug, :id, :available_on

    attribute :names do
      get_all_name_translations
    end
    attribute :prices do
      get_all_prices
    end
    attribute :all_images do
      get_all_images
    end
  end

  def get_all_name_translations
    self.translations.pluck(:locale, :name).to_h
  end

  def get_all_prices
    all_prices = self.prices.pluck(:currency, :price).to_h
    default_price = all_prices[self.currency] = self.price.to_s
    all_prices
  end

  def get_all_images
    self.images.map { |image| {attributes: {styles: [url: "#{image.attachment.key}#{File.extname(image.attachment.filename.to_s)}"]}} }
  end
end

# ::Spree::Product.prepend MyStore::Spree::ProductDecorator if ::Spree::Product.included_modules.exclude?(MyStore::Spree::ProductDecorator)
  