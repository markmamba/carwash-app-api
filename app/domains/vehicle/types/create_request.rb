# typed: true

module Vehicle
  module Types
    class CreateRequest

      extend T::Sig

      sig { returns(T.nilable(String)) }
      attr_reader :type_name

      sig { returns(T.nilable(Float)) }
      attr_reader :base_price

      sig { params(params: ActionController::Parameters).void }
      def initialize(params:)
        permitted_params = params.permit(
          :type_name,
          :base_price
        )
        @type_name = permitted_params[:type_name]
        @base_price = permitted_params[:base_price]
      end
    end
  end
end