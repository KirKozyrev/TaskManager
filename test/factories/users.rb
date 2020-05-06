FactoryBot.define do
  factory :user, aliases: [:admin, :developer, :manager] do
    sequence :first_name do |n|
      "FirstName#{n}"
    end
    sequence :last_name do |n|
      "LastName#{n}"
    end
    sequence :password do |n|
      "Password#{n}"
    end
    sequence :email do |n|
      "user#{n}@test.com"
    end
    sequence :avatar do |n|
      "Avatar#{n}"
    end

    trait :admin do
      type { 'admin' }
    end
    trait :developer do
      type { 'developer' }
    end
    trait :manager do
      type { 'manager' }
    end
  end
end
