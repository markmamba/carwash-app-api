# typed: true

# Provides base params to any sub-domain IndexRequest objects
# Some::Domain::IndexRequest objects must extend this class
class BaseIndexRequest

  extend T::Sig

  DEFAULT_PAGE      = 1
  DEFAULT_PAGE_SIZE = 10
  DEFAULT_ORDER_BY  = ''
  DEFAULT_ORDER_DIR = 'asc'

  # Provides the full permitted params for `to_json` 
  sig { returns(ActionController::Parameters) }
  attr_reader :permitted_params

  sig { returns(Integer) }
  attr_reader :page

  sig { returns(Integer) }
  attr_reader :page_size

  sig { returns(String) }
  attr_reader :order_by

  sig { returns(String) }
  attr_reader :order_dir

  sig { params(params: ActionController::Parameters).void }
  def initialize(params:)
    # Build the complete list of params that will be permitted from subclass
    base_params       = [ :page, :page_size, :order_by, :order_dir ]
    custom_params     = custom_permitted_params()
    all_params        = base_params.concat(custom_params)

    @permitted_params = params.permit(all_params)
    # Assign to attributes defined in this class (BaseIndexRequest)
    base_params()
    # Assign to attributes defined in subclass
    custom_params()
  end

  # Returns a json representation of permitted params.
  sig { returns(String) }
  def to_json()
    permitted_params.to_h.to_json()
  end

  private

    sig { void }
    def base_params()
      # Handles decimals and strings
      page_param      = permitted_params[:page].to_i
      page_size_param = permitted_params[:page_size].to_i

      @page      = DEFAULT_PAGE
      @page      = page_param if page_param.positive?

      @page_size        = DEFAULT_PAGE_SIZE
      @page_size        = page_size_param if page_size_param.between?(1, 100)

      # Use subclass constants if defined, fall back to BaseIndexRequest otherwise
      default_order_by  = self.class.const_get(:DEFAULT_ORDER_BY) rescue DEFAULT_ORDER_BY
      default_order_dir = self.class.const_get(:DEFAULT_ORDER_DIR) rescue DEFAULT_ORDER_DIR

      @order_by  = permitted_params[:order_by]  || default_order_by
      @order_dir = permitted_params[:order_dir] || default_order_dir
    end

    sig { returns(T::Array[Symbol]) }
    def custom_permitted_params
      # subclasses implement this
      []
    end

    # Override this in subclasses to extract additional params
    sig { void }
    def custom_params()
      # Subclasses implement this
    end

end
