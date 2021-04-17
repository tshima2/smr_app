FactoryBot.define do
  factory :comment, class: Comment do
    content { Faker::Beer.brand }
    user_id { User.ids.sample }
    site_id { Site.ids.sample }
  end
end
