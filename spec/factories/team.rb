FactoryBot.define do

  #DefaultTeam, All First User is assigned it.
  factory :default_team, class: Team do
    name { 'DefaultTeam' }
    owner_id { User.find_by(name: 'default_owner').id }
  end

  #Normal Team
  factory :team, class: Team do
    name { Faker::Team.name }
    owner_id { User.ids.sample }
  end
end
