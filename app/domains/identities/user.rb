# typed: true

module Identities
  class User < ApplicationRecord
    self.table_name = 'identities_users'

    extend T::Sig

    # Associations
    has_one :staff_profile, class_name: 'Workforce::Staff', foreign_key: 'user_id'
    has_many :created_expenses, class_name: 'Finance::Expense', foreign_key: 'created_by_id'
    has_many :approved_expenses, class_name: 'Finance::Expense', foreign_key: 'approved_by_id'

    # Scopes
    scope :by_type, ->(type) { where(user_type: type) }
    scope :admins, -> { where(user_type: 'admin') }
    scope :staff, -> { where(user_type: 'staff') }
    scope :customers, -> { where(user_type: 'customer') }

    # Instance methods
    sig { returns(String) }
    def full_name
      "#{first_name} #{last_name}".strip
    end

    sig { returns(T::Boolean) }
    def admin?
      user_type == 'admin'
    end

    sig { returns(T::Boolean) }
    def staff?
      user_type == 'staff'
    end

    sig { returns(T::Boolean) }
    def customer?
      user_type == 'customer'
    end

    sig { returns(T.nilable(Workforce::Staff)) }
    def staff_profile
      return nil unless staff?
      super
    end
  end
end
