class ApplicationController < ActionController::API

  rescue_from(StandardError, with: :standard_error)
  rescue_from(Errors::BaseError, with: :base_error)
  rescue_from(ActiveRecord::RecordNotFound, with: :record_not_found)

  def base_error(error)
    status = error.status
    render(
      json: {
        status_name: error.status_name,
        status: status,
        message: error.message,
        code: error.code,
        title: error.title,
        server: error.server
      }
    )
  end

  def record_not_found(error)
    print_error_locally(error)
    render(
      json:   {
        status_name:  'not_found',
        status:       404,
        messages:     [ "Couldn't find #{error.model} with #{error.primary_key}=#{error.id}" ],
        code:         'record_not_found',
        title:        'Record Not Found',
        debug_values: {
          error.primary_key => error.id
        },
        server:       nil
      },
      status: :not_found
    )
  end

  def standard_error(error)
    print_error_locally(error)

    render(
      json:   {
        status_name: 'internal_server_error',
        status:      500,
        message:     'An unexpected error occurred. Our team has been notified.',
        code:        'internal_server_error',
        title:       "We're sorry, something went wrong.",
        server:      'api'
      },
      status: :internal_server_error
    )
  end

  private

  def print_error_locally(error)
    if Rails.env.development?
      Rails.logger.error "\n\n[ERROR] #{error.class}: #{error.message}"
      Rails.logger.error error.backtrace.join("\n") if error.backtrace
    end
  end
end
