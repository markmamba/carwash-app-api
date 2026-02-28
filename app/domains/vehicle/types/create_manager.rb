# typed: true

module Vehicle
  module Types
    class CreateManager
      extend T::Sig

      sig {
        params(request: Vehicle::Types::CreateRequest)
        .returns(Vehicle::Type)
      }
      def self.execute(request:)
        validator = Vehicle::Types::CreateValidator.new(request: request)
        unless validator.valid?
          raise Errors::ValidationError.new(
            messages: validator.errors.messages,
            debug_values: { request: request },
            title: 'Validation failed for vehicle type creation'
          )
        end

        vehicle_type = Vehicle::Type.new(
          type_name: request.type_name,
          base_price: request.base_price
        )

        vehicle_type.save!
        return vehicle_type
      end
    end
  end
end