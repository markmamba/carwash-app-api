# typed: true

module Finance
  class Expense < ApplicationRecord
    self.table_name = 'finance_expenses'

    extend T::Sig

    # Associations
    belongs_to :created_by, class_name: 'Identities::User'
    belongs_to :approved_by, class_name: 'Identities::User', optional: true

    # Scopes
    scope :for_date_range, ->(start_date, end_date) { where(expense_date: start_date..end_date) }
    scope :by_category, ->(category) { where(category: category) }
    scope :by_status, ->(status) { where(status: status) }
    scope :pending, -> { where(status: 'pending') }
    scope :approved, -> { where(status: 'approved') }
    scope :rejected, -> { where(status: 'rejected') }
    scope :paid, -> { where(status: 'paid') }
    scope :recent, -> { order(expense_date: :desc, created_at: :desc) }

    # Instance methods
    sig { returns(T::Boolean) }
    def pending?
      status == 'pending'
    end

    sig { returns(T::Boolean) }
    def approved?
      status == 'approved'
    end

    sig { returns(T::Boolean) }
    def rejected?
      status == 'rejected'
    end

    sig { returns(T::Boolean) }
    def paid?
      status == 'paid'
    end

    sig { returns(T::Boolean) }
    def approved?
      !approved_by.nil? && !approved_at.nil?
    end

    sig { void }
    def approve!(approver: nil)
      self.status = 'approved'
      self.approved_by = approver
      self.approved_at = Time.current
      save!
    end

    sig { void }
    def reject!(approver: nil)
      self.status = 'rejected'
      self.approved_by = approver
      self.approved_at = Time.current
      save!
    end

    sig { void }
    def mark_as_paid!
      return unless approved?
      self.status = 'paid'
      save!
    end

    sig { returns(String) }
    def display_status
      status.humanize
    end

    sig { returns(String) }
    def display_category
      category.humanize
    end

    # Class methods
    sig { params(start_date: Date, end_date: Date).returns(Money) }
    def self.total_expenses_for_period(start_date, end_date)
      for_date_range(start_date, end_date).sum(:amount)
    end

    sig { params(start_date: Date, end_date: Date).returns(T::Hash[String, Money]) }
    def self.expenses_by_category_for_period(start_date, end_date)
      for_date_range(start_date, end_date)
        .group(:category)
        .sum(:amount)
    end

    sig { returns(T::Array[Finance::Expense]) }
    def self.pending_approval
      pending.includes(:created_by, :approved_by)
    end

    sig { params(user: Identities::User).returns(T::Array[Finance::Expense]) }
    def self.created_by_user(user)
      where(created_by: user)
    end

    sig { params(user: Identities::User).returns(T::Array[Finance::Expense]) }
    def self.approved_by_user(user)
      where(approved_by: user)
    end

    sig { returns(T::Hash[String, Integer]) }
    def self.count_by_status
      group(:status).count
    end
  end
end
