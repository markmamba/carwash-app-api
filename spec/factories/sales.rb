FactoryBot.define do
  factory :sale do
    date { "2026-02-28" }
    vehicle_plate { "MyString" }
    service_fee { "9.99" }
    staff { nil }
    vehicle_type { nil }
  end
end
