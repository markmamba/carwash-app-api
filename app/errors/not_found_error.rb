# typed: true

module Errors
  class NotFoundError < Errors::BaseError

    extend T::Sig

    sig { params(params: T::Hash[Symbol, T.untyped]).void }
    def initialize(params = {})
      @status_name = :not_found
      @status      = Rack::Utils::SYMBOL_TO_STATUS_CODE[@status_name]
      @level       = :info

      super(**params)
    end

  end
end
