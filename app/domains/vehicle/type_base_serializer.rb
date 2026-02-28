module Vehicle
  class TypeBaseSerializer < Panko::Serializer
    attributes(
      :id,
      :type_name,
      :base_price
    )
  end
end