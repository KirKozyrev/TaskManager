FactoryBot.define do
  factory :user do
    first_name
    last_name
    password
    email
    avatar { generate :string }
  end

  factory :admin do
    type { 'admin' }
  end
  factory :developer do
    type { 'developer' }
  end
  factory :manager do
    type { 'manager' }
  end
end
