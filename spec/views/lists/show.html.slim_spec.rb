require 'rails_helper'

RSpec.describe "lists/show", type: :view do
  before(:each) do
    @list = assign(:list, List.create!(
      :user_id => 1,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
  end
end
