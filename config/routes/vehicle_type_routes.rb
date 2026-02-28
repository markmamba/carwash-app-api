namespace :vehicle do
  namespace :types do
    post '', controller: '/vehicle/types', action: 'create'
    patch ':vehicle_type_id', controller: '/vehicle/types', action: 'update'
  end
end