# module MyStore
#   module Spree
#     module Api
#       module ProductsControllerDecorator
#         include ::Spree::Api::V2::CollectionOptionsHelpers
#
#         def index
#           render_serialized_payload do
#             serialize_collection(paginated_collection)
#             # ::Spree::Api::Dependencies.storefront_product_serializer.constantize.new(::Spree::Product.all).serializable_hash
#           end
#           # render json: {error: true}
#         end
#       end
#     end
#   end
# end
#
# ::Spree::Api::V2::Storefront::ProductsController.prepend MyStore::Spree::Api::ProductsControllerDecorator if ::Spree::Api::V2::Storefront::ProductsController.included_modules.exclude?(MyStore::Spree::Api::ProductsControllerDecorator)