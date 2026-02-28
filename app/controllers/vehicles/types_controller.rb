module Vehicles
  class TypesController < ApplicationController

    def create
      request = Vehicle::Types::CreateRequest.new(params: params)
      vehicle_type = Vehicle::Types::CreateManager.execute(request: request)
      render(
        json: ::Vehicle::TypeBaseSerializer.new.serialize_to_json(vehicle_type),
        status: :created
      )
    end
  end
end