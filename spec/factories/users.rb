FactoryBot.define do
  factory :user do
    username { FFaker::Internet.user_name }
    password { FFaker::Internet.password }
  end
end
