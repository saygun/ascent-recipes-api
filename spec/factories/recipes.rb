FactoryBot.define do
  factory :recipe do
    sequence(:id) { |n| n }
    href { Faker::Internet.url }
    thumbnail { Faker::Internet.url }
    title { Faker::Food.dish }
    ingredients { Faker::Food.ingredient }
  end
end
