# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:provider) { |n| "#{n}_#{Faker::Internet.user_name}" }
    sequence(:uid) { |n| "#{n}-#{Faker::Internet.email}" }
    role "player"
    sequence(:info) { |n| { email: "#{n}-#{Faker::Internet.email}", name: Faker::Name.name }}
  end

  factory :admin, parent: :user do
    role "admin"
  end

  factory :banned_user, parent: :user do
    banned true
  end
end
