FactoryBot.define do
  sequence(:email, aliases: [:sender, :receiver]) { |n| "user#{n}@test.com" }
  sequence(:name, aliases: [:first_name, :last_name]) { |n| "Name#{n}" }
  sequence(:password) { |n| "Password#{n}" }
  sequence(:avatar) { |n| "Avatar#{n}" }
  sequence(:description) { |n| "Description#{n}" }
  sequence(:expired_at) { |n| "#{Date.today + n}" }
end