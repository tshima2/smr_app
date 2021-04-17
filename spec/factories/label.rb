FactoryBot.define do
  factory :label, class: Label do
    title { Faker::Beer.brand }
    team_id { Team.ids.sample }
  end
end
