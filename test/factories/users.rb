FactoryBot.define do
  factory :user, aliases: [:admin, :developer, :manager] do
    first_name { generate :name_string }
    last_name { generate :name_string }
    password { generate :string }
    email
    avatar { generate :string }

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
