# typed: true

module Vehicle
  module Types
    class UpdateManager
      extend T::Sig

      sig {
        params(request: Vehicle::Types::UpdateRequest)
        .returns(Vehicle::Type)
      }
      def self.execute(request:)
        validator = Vehicle::Types::UpdateValidator.new(request: request)
        if validator.invalid?
          raise Errors::ValidationError.new(
            messages: validator.errors.messages,
            request: JSON.parse(request.to_json, symbolize_names: true),
            title: 'Validation failed for vehicle type update'
          )
        end

        vehicle_type = Vehicle::Type.find(request.vehicle_type_id)
        vehicle_type.update!(
          type_name: request.type_name,
          base_price: request.base_price
        )

        return vehicle_type
      end
    end
  end
end