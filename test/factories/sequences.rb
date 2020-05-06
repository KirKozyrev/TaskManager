FactoryBot.define do
  sequence :name_string do |n|
    "Name#{n}"
  end
  sequence :email do |n|
    "user#{n}@mail.com"
  end
  sequence :string do |n|
    "string#{n}"
  end
  sequence :date do |n|
    (Date.today + n).to_s
  end
end
