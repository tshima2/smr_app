FactoryBot.define do
  factory :comment, class: Comment do
    content { Faker::Beer.brand }
    user_id { User.ids.sample }
    site_id { Site.ids.sample }
  end

  factory :comment_filter_1, class: Comment do
    content { "新宿" }
    user_id { User.ids.sample }
    site_id { Site.ids.sample }
  end
  factory :comment_filter_2, class: Comment do
    content { "新橋" }
    user_id { User.ids.sample }
    site_id { Site.ids.sample }
  end
  factory :comment_filter_3, class: Comment do
    content { "渋谷" }
    user_id { User.ids.sample }
    site_id { Site.ids.sample }
  end
end
