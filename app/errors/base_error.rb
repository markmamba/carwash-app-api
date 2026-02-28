# typed: true

# All errors should inherit this class
class BaseError < StandardError

  extend T::Sig

  # HTTP Request status code (e.g 404)
  sig { returns(Integer) }
  attr_reader :status

  # Human readable HTTP Request status
  # Required
  sig { returns(T.any(Symbol, String)) }
  attr_reader :status_name

  # Project's specific error code.
  # Defaults to error class
  sig { returns(String) }
  attr_reader :code

  # Human readable description of the error.
  sig { returns(String) }
  attr_reader :title

  # Hash of keys that are name of offending params.
  # Follows ActiveModel::Validation.errors.messages structure
  # ### Example
  #     {
  #       order_id: [
  #         'Order does not exist',
  #         'Order does not have items'
  #       ],
  #       param_2: ['error message C for param_2']
  #     }
  # @return [Hash]
  sig { returns(T::Hash[Symbol, T::Array[String]]) }
  attr_reader :messages

  # Name of the server that caused the error.
  #   - api
  #   - third-party
  sig { returns(String) }
  attr_reader :server

  # Hash of variables with their values at the point of the error
  #
  # ### Note
  # This values **SHOULD NOT** be rendered in BaseControllers or ApplicationControllers to the client.
  # This values are to be rendered to the developer (e.g. send this object to sentry)
  #
  # ### Example
  #     {
  #       order_id: 1,
  #       customer_id: 2,
  #       var_3: 'value for var_3'
  #     }
  #
  sig { returns(T::Hash[Symbol, T.untyped]) }
  attr_reader :debug_values

  # Boolean flag that tells children base_error classes to skip sending error to sentry
  # NOTE: this is a temporary solution
  # Sentry invocation should be done on controller (on rescue_from), not inside the error class itself
  # but because currently there are so many "rescue_from" methods in the base_controller, we're gonna use
  # use this temporary solution first.
  sig { returns(T::Boolean) }
  attr_reader :skip_sentry

  sig { returns(String) }
  attr_reader :class_name

  sig { returns(Hash) }
  attr_reader :request

  sig { returns(Symbol) }
  attr_reader :level

  sig { params(
    messages:     T::Hash[Symbol, T::Array[String]],
    debug_values: T::Hash[Symbol, T.untyped],
    options:      T.untyped
  ).void
  }
  def initialize(messages: {}, debug_values: {}, **options)
    super
    @code         = options[:code] || self.class.name
    @title        = options[:title] || "We're sorry, something went wrong."
    @server       = options[:server] || 'api'
    @messages     = messages
    @debug_values = debug_values
    @class_name   = options[:class_name] || self.class.name
    @skip_sentry  = options[:skip_sentry] || false
    @request      = options[:request]
  end

end
