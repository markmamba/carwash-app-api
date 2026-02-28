namespace :vehicles do
  namespace :types do
    post '', controller: '/vehicles/types', action: 'create'
    patch ':vehicle_type_id', controller: '/vehicles/types', action: 'update'
  end
end