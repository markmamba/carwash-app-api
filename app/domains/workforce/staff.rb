# typed: true

module Workforce
  class Staff < Identities::User
    self.table_name = 'workforce_staffs'

    extend T::Sig

    # Associations
    belongs_to :user, class_name: 'Identities::User'
    has_many :schedules, class_name: 'Workforce::Schedule', foreign_key: 'staff_id'
    has_many :sales, class_name: 'Finance::Sale', foreign_key: 'staff_id'

    # Scopes
    scope :active, -> { where(status: 'active') }
    scope :by_role, ->(role) { where(role: role) }
    scope :by_department, ->(department) { where(department: department) }

    # Instance methods
    sig { returns(String) }
    def display_name
      user&.full_name || staff_id
    end

    sig { returns(T::Boolean) }
    def active?
      status == 'active'
    end

    sig { returns(T::Boolean) }
    def inactive?
      status == 'inactive'
    end

    sig { returns(T::Boolean) }
    def suspended?
      status == 'suspended'
    end

    sig { returns(T::Array[Workforce::Schedule]) }
    def upcoming_schedules
      schedules.where('shift_date >= ?', Date.current).order(:shift_date)
    end

    sig { params(start_date: Date, end_date: Date).returns(T::Array[Finance::Sale]) }
    def sales_in_period(start_date:, end_date:)
      sales.where(date: start_date..end_date)
    end

    sig { returns(Money) }
    def total_commission_for_period(start_date:, end_date:)
      sales_in_period(start_date: start_date, end_date: end_date)
           .sum(:staff_commission)
    end

    # Class methods
    sig { params(email: String).returns(T.nilable(Workforce::Staff)) }
    def self.find_by_email(email)
      joins(:user).where(identities_users: { email: email }).first
    end

    sig { returns(T::Array[Workforce::Staff]) }
    def self.with_sales_today
      joins(:sales).where(finance_sales: { date: Date.current }).distinct
    end
  end
end
