class Sale < ApplicationRecord
  belongs_to :staff
  belongs_to :vehicle_type
end
