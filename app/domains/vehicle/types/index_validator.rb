module Vehicle
  module Types
    class IndexValidator < BaseIndexValidator

      include ActiveModel::Validations

      extend T::Sig

      attr_reader(:type_name)

      def initialize(request:)
        super(request:)
        @type_name = request.type_name
      end

      private

        def valid_order_columns
          [
            'id',
            'type_name',
            'base_price',
            'created_at',
            'updated_at'
          ]
        end

    end
  end
end
