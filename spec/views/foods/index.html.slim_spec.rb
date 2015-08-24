require 'rails_helper'

RSpec.describe "foods/index", type: :view do
  before(:each) do
    assign(:foods, [
      Food.create!(
        :name => "Name",
        :unit_name => "Unit Name",
        :user_id => 1
      ),
      Food.create!(
        :name => "Name",
        :unit_name => "Unit Name",
        :user_id => 1
      )
    ])
  end

  it "renders a list of foods" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Unit Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
