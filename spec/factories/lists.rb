FactoryGirl.define do
  factory :list do
    user
    sequence(:name) { |n| "List #{n}" }
    start_date { Date.yesterday }
    end_date { Date.tomorrow }
  end
end
