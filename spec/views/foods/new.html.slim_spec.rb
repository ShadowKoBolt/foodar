require 'rails_helper'

RSpec.describe "foods/new", type: :view do
  before(:each) do
    assign(:food, Food.new(
      :name => "MyString",
      :unit_name => "MyString",
      :user_id => 1
    ))
  end

  it "renders new food form" do
    render

    assert_select "form[action=?][method=?]", foods_path, "post" do

      assert_select "input#food_name[name=?]", "food[name]"

      assert_select "input#food_unit_name[name=?]", "food[unit_name]"

      assert_select "input#food_user_id[name=?]", "food[user_id]"
    end
  end
end
