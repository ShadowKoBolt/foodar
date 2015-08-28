FactoryGirl.define do
  factory :meal do
    user
    recipe
    date { Date.today }
    time "breakfast"
    serves 1
  end
end
