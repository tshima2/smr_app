FactoryBot.define do
  factory :team, class: Team do
    name { Faker::Team.name }
    owner_id { User.ids.sample }
  end
end
