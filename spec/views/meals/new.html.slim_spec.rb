require "rails_helper"

RSpec.describe "meals/new", type: :view do
  before(:each) do
    assign(:meal, Meal.new(
                    recipe_id: 1,
                    time: "MyString",
                    serves: 1.5,
                    user_id: 1
    ))
  end

  it "renders new meal form" do
    render

    assert_select "form[action=?][method=?]", meals_path, "post" do
      assert_select "input#meal_recipe_id[name=?]", "meal[recipe_id]"

      assert_select "input#meal_time[name=?]", "meal[time]"

      assert_select "input#meal_serves[name=?]", "meal[serves]"

      assert_select "input#meal_user_id[name=?]", "meal[user_id]"
    end
  end
end
