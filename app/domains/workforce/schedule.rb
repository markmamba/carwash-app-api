# typed: true

module Workforce
  class Schedule < ApplicationRecord
    self.table_name = 'workforce_schedules'

    extend T::Sig

    # Associations
    belongs_to :staff, class_name: 'Workforce::Staff'

    # Scopes
    scope :for_date, ->(date) { where(shift_date: date) }
    scope :for_date_range, ->(start_date, end_date) { where(shift_date: start_date..end_date) }
    scope :by_status, ->(status) { where(status: status) }
    scope :upcoming, -> { where('shift_date >= ?', Date.current) }
    scope :past, -> { where('shift_date < ?', Date.current) }

    # Instance methods
    sig { returns(T::Boolean) }
    def scheduled?
      status == 'scheduled'
    end

    sig { returns(T::Boolean) }
    def present?
      status == 'present'
    end

    sig { returns(T::Boolean) }
    def absent?
      status == 'absent'
    end

    sig { returns(ActiveSupport::Duration) }
    def duration
      return ActiveSupport::Duration.days(0) unless start_time && end_time
      end_time - start_time
    end

    sig { returns(String) }
    def time_range
      "#{start_time&.strftime('%I:%M %p')} - #{end_time&.strftime('%I:%M %p')}"
    end

    # Class methods
    sig { params(date: Date).returns(T::Array[Workforce::Schedule]) }
    def self.for_today
      for_date(Date.current)
    end

    sig { params(staff: Workforce::Staff, date: Date).returns(T.nilable(Workforce::Schedule)) }
    def self.for_staff_on_date(staff:, date:)
      where(staff: staff, shift_date: date).first
    end

    sig { params(date: Date).returns(T::Array[Workforce::Staff]) }
    def self.staff_scheduled_for(date)
      includes(:staff).for_date(date).map(&:staff)
    end
  end
end
