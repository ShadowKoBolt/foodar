require 'rails_helper'

RSpec.describe "meals/index", type: :view do
  before(:each) do
    assign(:meals, [
      Meal.create!(
        :recipe_id => 1,
        :time => "Time",
        :serves => 1.5,
        :user_id => 2
      ),
      Meal.create!(
        :recipe_id => 1,
        :time => "Time",
        :serves => 1.5,
        :user_id => 2
      )
    ])
  end

  it "renders a list of meals" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Time".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
