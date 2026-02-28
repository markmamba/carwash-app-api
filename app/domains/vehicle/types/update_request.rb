# typed: true

module Vehicle
  module Types
    class UpdateRequest

      extend T::Sig

      sig { returns(T.nilable(Integer)) }
      attr_reader :vehicle_type_id

      sig { returns(T.nilable(String)) }
      attr_reader :type_name

      sig { returns(T.nilable(Float)) }
      attr_reader :base_price

      sig { params(params: ActionController::Parameters).void }
      def initialize(params:)
        permitted_params = params.permit(
          :vehicle_type_id,
          :type_name,
          :base_price
        )
        @vehicle_type_id = permitted_params[:vehicle_type_id]&.to_i
        @type_name = permitted_params[:type_name]
        @base_price = permitted_params[:base_price]&.to_f
      end
    end
  end
end