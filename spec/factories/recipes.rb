FactoryGirl.define do
  factory :recipe do
    user
    sequence(:name) { |n| "Recipe #{n}" }
    serves 1
  end
end
