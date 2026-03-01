# typed: true

module Vehicle
  module Types
    class IndexRequest < BaseIndexRequest
      extend T::Sig

      # Domain-specific constants for sorting
      DEFAULT_ORDER_BY  = "type_name"
      DEFAULT_ORDER_DIR = "asc"

      sig { returns(T.nilable(String)) }
      attr_reader :type_name

      sig { returns(T.nilable(Float)) }
      attr_reader :base_price

      private

      sig { returns(T::Array[Symbol]) }
      def custom_permitted_params
        [
          :type_name,
          :base_price
        ]
      end

      sig { void }
      def custom_params
        @type_name  = @permitted_params[:type_name]
        @base_price = @permitted_params[:base_price]&.to_f
        @order_by   = @permitted_params[:order_by] || DEFAULT_ORDER_BY
        @order_dir  = @permitted_params[:order_dir] || DEFAULT_ORDER_DIR
      end
    end
  end
end
