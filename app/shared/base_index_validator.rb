# typed: true

# Provides validation on default index params:
# - :order_by
# - :order_dir
# Does not validate :page and :page_size
# - :page - set to default if is not positive
# - :page_size - set to default if not between 1-100
class BaseIndexValidator

  include ActiveModel::Validations
  extend T::Sig

  VALID_ORDER_DIR = %w[asc desc].freeze


  sig { returns(String) }
  attr_reader :order_by

  sig { returns(String) }
  attr_reader :order_dir

  validate(
    :order_by_valid?,
    :order_dir_valid?,
  )

  sig { params(request: BaseIndexRequest).void }
  def initialize(request:)
    @order_by  = T.let(request.order_by.downcase, String)
    @order_dir = T.let(request.order_dir.downcase, String)
  end

  private

    sig { void }
    def order_by_valid?
      # defaults are assigned if endpoint does not send order_by params
      return if order_by.blank?
      return if valid_order_columns.include?(order_by)
      errors.add(
        :order_by,
        "order_by only accepts: #{valid_order_columns.join(', ')}"
      )
    end

    sig { void }
    def order_dir_valid?
      # defaults are assigned if endpoint does not send order_dir params
      return if order_dir.blank?
      return if VALID_ORDER_DIR.include?(order_dir)
      errors.add(
        :order_dir,
        "order_dir only accepts: #{VALID_ORDER_DIR.join(', ')}"
      )
    end

    # Override this in subclasses
    sig { returns(T::Array[String]) }
    def valid_order_columns()
      raise NotImplementedError, "#{self.class.name} must implement #valid_order_columns"
    end

end
