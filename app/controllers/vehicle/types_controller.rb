module Vehicle
  class TypesController < ApplicationController

    # GET /vehicle/types
    def index
      request = Vehicle::Types::IndexRequest.new(params: params)
      collection = Vehicle::Types::IndexManager.execute(request: request)

      paginate_and_render(
        request: request,
        collection: collection,
        serializer: ::Vehicle::TypeBaseSerializer,
        object_name: 'vehicle_types'
      )
    end

    # POST /vehicle/types
    def create
      request = Vehicle::Types::CreateRequest.new(params: params)
      vehicle_type = Vehicle::Types::CreateManager.execute(request: request)
      render(
        json: ::Vehicle::TypeBaseSerializer.new.serialize_to_json(vehicle_type),
        status: :created
      )
    end

    # PATCH /vehicle/types/:vehicle_type_id
    def update
      request = Vehicle::Types::UpdateRequest.new(params: params)
      vehicle_type = Vehicle::Types::UpdateManager.execute(request: request)
      render(
        json: ::Vehicle::TypeBaseSerializer.new.serialize_to_json(vehicle_type),
        status: :ok
      )
    end
  end
end