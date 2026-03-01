module PaginationHelper

  include Pagy::Backend

  # Renders a paginated collection with a standardized JSON format.
  # @param request [Object, nil] The request object containing pagination parameters.
  #   If nil, it defaults to using `params` from the controller context.
  # @param collection [ActiveRecord::Relation] The ActiveRecord collection to paginate.
  # @param serializer [Panko::Serializer] The Panko serializer class to use for each item.
  # @param object_name [String] The name of the key in the JSON response for the collection items.
  #   Defaults to 'data'.
  # @param include_metadata [Boolean] Whether to include pagination metadata in the response.
  def paginate_and_render(request: nil, collection:, serializer:, object_name: 'data', include_metadata: true)
    # Extract page and limit from request parameters, falling back to default pagy options
    pagy_options = {}

    # Determine 'page' parameter:
    # 1. Check if the explicit 'request' object has a 'page' method and it's present.
    # 2. If neither, Pagy will use its default (usually 1).
    if request.respond_to?(:page) && request.page.present?
      pagy_options[:page] = request.page
    end

    # Determine 'limit' (items per page) parameter:
    # 1. Check if the explicit 'request' object has a 'page_size' method and it's present.
    # 2. If none of the above, Pagy will use its default (Pagy::DEFAULT[:items]).
    if request.respond_to?(:page_size) && request.page_size.present?
      pagy_options[:limit] = request.page_size
    end

    # Paginate the collection using Pagy
    if collection.is_a?(Array)
      pagy, items = pagy_array(collection, **pagy_options)
    else
      pagy, items = pagy(collection, **pagy_options)
    end

    # Serialize the items using Panko
    serialized_items = JSON.parse(
      Panko::ArraySerializer.new(
        items,
        each_serializer: serializer # Use the provided serializer
      ).to_json
    )

    # Build the base JSON response hash
    response_hash = {
      object_name => serialized_items
    }

    # Conditionally add metadata if include_metadata is true
    if include_metadata
      response_hash[:meta] = {
        page:      pagy.page,
        page_size: pagy.limit,
        next:      pagy.next,
        last:      pagy.last,
        count:     pagy.count,
        pages:     pagy.pages
      }
    end

    # Render the JSON response with standardized format
    render(json: response_hash, status: :ok)
  end

end
