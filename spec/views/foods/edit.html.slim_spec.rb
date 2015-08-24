require 'rails_helper'

RSpec.describe "foods/edit", type: :view do
  before(:each) do
    @food = assign(:food, Food.create!(
      :name => "MyString",
      :unit_name => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit food form" do
    render

    assert_select "form[action=?][method=?]", food_path(@food), "post" do

      assert_select "input#food_name[name=?]", "food[name]"

      assert_select "input#food_unit_name[name=?]", "food[unit_name]"

      assert_select "input#food_user_id[name=?]", "food[user_id]"
    end
  end
end
