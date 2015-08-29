require "rails_helper"

RSpec.describe "foods/show", type: :view do
  before(:each) do
    @food = assign(:food, Food.create!(
                            name: "Name",
                            unit_name: "Unit Name",
                            user_id: 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Unit Name/)
    expect(rendered).to match(/1/)
  end
end
