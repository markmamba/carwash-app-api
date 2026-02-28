# typed: true

class InternalServerError < Errors::BaseError

  extend T::Sig

  sig { params(params: T::Hash[Symbol, T.untyped]).void }
  def initialize(params = {})
    @status_name = :internal_server_error
    @status      = Rack::Utils::SYMBOL_TO_STATUS_CODE[@status_name]
    @level       = :error

    super(**params)
  end
end

