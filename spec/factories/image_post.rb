FactoryBot.define do
  factory :image_post, class: ImagePost do
    image { File.open("#{Rails.root.to_s}/public/images_for_seed/#{rand(1..7)}.jpg") }
    user_id { User.ids.sample }
    site_id { Site.ids.sample }
  end
end
  