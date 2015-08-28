FactoryGirl.define do
  factory :food do
    sequence(:name) { |n| "Food #{n}" }
    unit_name 'g'
    user
  end

end
