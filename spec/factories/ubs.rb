FactoryBot.define do

  factory :ubs do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    phone { Faker::Name.name }
    geocode {
      {
        lat: Faker::Address.latitude.to_f,
        long: Faker::Address.longitude.to_f
      }
    }
    scores {
      {
        size: (1..3).to_a.sample,
        adaptation_for_seniors: (1..3).to_a.sample,
        medical_equipment: (1..3).to_a.sample,
        medicine: (1..3).to_a.sample,
      }
    }
  end

end
