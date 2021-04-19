FactoryBot.define do
  factory :site, class: Site do
    name { Faker::Name.last_name }
    address { Faker::Address.city }
    memo { Faker::Beer.brand}
    user_id { User.ids.sample }
    team_id { Team.ids.sample }
  end
end
