FactoryBot.define do
  #DefaultTeam Owner User
  factory :default_owner, class: User do
    name { 'default_owner' }
    email { 'default_owner@example.com' }
    password { 'passwd' }
    password_confirmation { 'passwd' }
  end

  #Normal User (name/email/passwd specified)
  factory :second_user, class: User do
    name { 'second_user' }
    email { 'second_user@example.com' }
    password { 'passwd' }
    password_confirmation { 'passwd' }
  end

  #Normal User (random)
  factory :user, class: User do
    name { Faker::Name.last_name }
    email { Faker::Internet.free_email }
    password=Faker::Internet.password(min_length: 6)
    password { password }
    password_confirmation { password }
  end

end
