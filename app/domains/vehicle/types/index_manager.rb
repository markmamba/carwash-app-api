# typed: true

module Vehicle
  module Types
    class IndexManager
      extend T::Sig

      sig { params(request: Vehicle::Types::IndexRequest).returns(ActiveRecord::Relation) }
      def self.execute(request:)
        validator = Vehicle::Types::IndexValidator.new(request: request)

        if validator.invalid?
          raise Errors::ValidationError.new(
            messages: validator.errors.messages,
            request: JSON.parse(request.to_json, symbolize_names: true),
            title: 'Validation failed for vehicle type index'
          )
        end

        # Start with all records
        scope = Vehicle::Type.all

        # Apply filters if present
        if request.type_name.present?
          scope = scope.where("type_name ILIKE ?", "%#{request.type_name}%")
        end

        if request.base_price.present?
          scope = scope.where(base_price: request.base_price)
        end

        # Apply sorting
        scope = scope.order("#{request.order_by} #{request.order_dir}")

        scope
      end
    end
  end
end