module Vehicles
  class TypesController < ApplicationController

    # POST /vehicles/types
    def create
      request = Vehicle::Types::CreateRequest.new(params: params)
      vehicle_type = Vehicle::Types::CreateManager.execute(request: request)
      render(
        json: ::Vehicle::TypeBaseSerializer.new.serialize_to_json(vehicle_type),
        status: :created
      )
    end

    # PATCH /vehicles/types/:vehicle_type_id
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