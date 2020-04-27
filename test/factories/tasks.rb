FactoryBot.define do
  factory :task do
    sequence(:name) {|n| "Name#{n}" }
    sequence(:description) {|n| "Description#{n}" }
    sequence(:author_id) {|n| n }
    sequence(:assignee_id) {|n| n }
    sequence(:state) {|n| "State#{n}" }
    sequence(:expired_at) {|n| "#{Date.today + n}" }
  end
end
