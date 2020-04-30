require_relative('global')

FactoryBot.define do
  factory :user, aliases: [:admin, :developer, :manager] do
    first_name
    last_name
    password
    email
    avatar

    trait :admin do
      type 'admin'
    end
    trait :developer do
      type 'developer'
    end
    trait :manager do
      type 'manager'
    end
  end
end
