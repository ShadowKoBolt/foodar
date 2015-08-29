require "rails_helper"

RSpec.describe "ingredients/index", type: :view do
  before(:each) do
    assign(:ingredients, [
      Ingredient.create!(
        recipe_id: 1,
        food_id: 2,
        amount: 1.5
      ),
      Ingredient.create!(
        recipe_id: 1,
        food_id: 2,
        amount: 1.5
      )
    ])
  end

  it "renders a list of ingredients" do
    render
    assert_select "tr>td", text: 1.to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 1.5.to_s, count: 2
  end
end
