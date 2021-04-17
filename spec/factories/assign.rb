FactoryBot.define do
  factory :assign, class: Assign do
    user_id { User.ids.sample }
    team_id { Team.ids.sample }
  end
end
