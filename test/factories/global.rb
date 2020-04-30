FactoryBot.define do
  sequence :email, aliases: [:sender, :receiver] do |n|
    "user#{n}@test.com"
  end
  sequence :name, aliases: [:first_name, :last_name] do |n|
    "Name#{n}"
  end
  sequence :password do |n|
    "Password#{n}"
  end
  sequence :avatar do |n|
    "Avatar#{n}"
  end
  sequence :description do |n|
    "Description#{n}"
  end
  sequence :expired_at do |n|
    "#{Date.today + n}"
  end
end