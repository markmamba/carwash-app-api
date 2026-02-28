# typed: true

module Vehicle
  module Types
    class UpdateValidator

      include ActiveModel::Validations

      attr_reader(
        :vehicle_type_id,
        :type_name,
        :base_price
      )

      validates_presence_of(:vehicle_type_id)
      validates_presence_of(:type_name)
      validates_presence_of(:base_price)
      validates_numericality_of(:base_price, greater_than: 0)
      validate(
        :base_price_valid?,
        if: -> { base_price.present? }
      )

      def initialize(request:)
        @vehicle_type_id = request.vehicle_type_id
        @type_name = request.type_name
        @base_price = request.base_price
      end

      private

        def base_price_valid?
          price_format = /\A\d+(\.\d{1,2})?\z/
          unless base_price.to_s.match?(price_format)
            errors.add(:base_price, "must be a valid price format (e.g., 15.00)")
          end
        end
    end
  end
end
