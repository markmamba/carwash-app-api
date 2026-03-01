namespace :vehicle do
  namespace :types do
    get '', controller: '/vehicle/types', action: 'index'
    post '', controller: '/vehicle/types', action: 'create'
    patch ':vehicle_type_id', controller: '/vehicle/types', action: 'update'
  end
end