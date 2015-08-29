require "rails_helper"

RSpec.describe "meals/show", type: :view do
  before(:each) do
    @meal = assign(:meal, Meal.create!(
                            recipe_id: 1,
                            time: "Time",
                            serves: 1.5,
                            user_id: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Time/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/2/)
  end
end
