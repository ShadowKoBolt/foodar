require "rails_helper"

RSpec.describe "recipes/show", type: :view do
  before(:each) do
    @recipe = assign(:recipe, Recipe.create!(
                                name: "Name",
                                serves: 1,
                                user_id: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
