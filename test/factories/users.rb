FactoryBot.define do
  factory :user, aliases: [:admin, :developer, :manager] do
    sequence(:first_name) {|n| "FirstName#{n}" }
    sequence(:last_name) {|n| "LastName#{n}" }
    sequence(:password) {|n| "Password#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    sequence(:avatar) { |n| "Avatar#{n}" }

    trait :admin do
      type "admin"
    end
    trait :developer do
      type "developer"
    end
    trait :manager do
      type "manager"
    end
  end
end
