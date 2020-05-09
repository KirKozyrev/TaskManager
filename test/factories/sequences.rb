FactoryBot.define do
  sequence :email do |n|
    "user#{n}@mail.com"
  end
  sequence :string, aliases: [:name, :first_name, :last_name, :password, :description] do |n|
    "string#{n}"
  end
  sequence :date, aliases: [:expired_at] do |n|
    (Date.today + n).to_s
  end
end
