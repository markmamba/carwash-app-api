# typed: true

module Finance
  class Sale < ApplicationRecord
    self.table_name = 'finance_sales'

    extend T::Sig

    # Associations
    belongs_to :staff, class_name: 'Workforce::Staff'
    belongs_to :vehicle_type, class_name: 'Vehicle::Type'

    # Scopes
    scope :for_date, ->(date) { where(date: date) }
    scope :for_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
    scope :for_vehicle_plate, ->(plate) { where('vehicle_plate ILIKE ?', "%#{plate}%") }
    scope :by_staff, ->(staff) { where(staff: staff) }
    scope :by_vehicle_type, ->(vehicle_type) { where(vehicle_type: vehicle_type) }
    scope :recent, -> { order(date: :desc, created_at: :desc) }

    # Instance methods
    sig { returns(Money) }
    def total_commission
      admin_commission + staff_commission
    end

    sig { returns(Money) }
    def profit
      service_fee - total_commission
    end

    sig { returns(Float) }
    def staff_commission_percentage
      return 0.0 if service_fee.zero?
      (staff_commission / service_fee * 100).round(2)
    end

    sig { returns(Float) }
    def admin_commission_percentage
      return 0.0 if service_fee.zero?
      (admin_commission / service_fee * 100).round(2)
    end

    # Class methods
    sig { params(date: Date).returns(T::Array[Finance::Sale]) }
    def self.for_today
      for_date(Date.current)
    end

    sig { returns(Money) }
    def self.total_revenue_for_date(date)
      for_date(date).sum(:service_fee)
    end

    sig { returns(Money) }
    def self.total_revenue_for_period(start_date, end_date)
      for_date_range(start_date, end_date).sum(:service_fee)
    end

    sig { returns(Money) }
    def self.total_profit_for_period(start_date, end_date)
      for_date_range(start_date, end_date).sum do |sale|
        sale.service_fee - (sale.admin_commission + sale.staff_commission)
      end
    end

    sig { params(start_date: Date, end_date: Date).returns(T::Hash[Workforce::Staff, Money]) }
    def self.commission_by_staff_for_period(start_date, end_date)
      for_date_range(start_date, end_date)
        .includes(:staff)
        .group_by(&:staff)
        .transform_values { |sales| sales.sum(&:staff_commission) }
    end

    sig { params(start_date: Date, end_date: Date).returns(T::Hash[Vehicle::Type, Integer]) }
    def self.count_by_vehicle_type_for_period(start_date, end_date)
      for_date_range(start_date, end_date)
        .joins(:vehicle_type)
        .group('vehicle_types.id', 'vehicle_types.type_name')
        .count
    end
  end
end
