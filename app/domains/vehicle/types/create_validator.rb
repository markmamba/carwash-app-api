module Vehicle
  module Types
    class CreateValidator

      include ActiveModel::Validations

      attr_reader(
        :type_name,
        :base_price
      )

      validates_presence_of(:type_name)
      validates_presence_of(:base_price)

      def initialize(request:)
        @type_name = request.type_name
        @base_price = request.base_price
      end
    end
  end
end