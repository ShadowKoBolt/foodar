require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:serves) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should validate_numericality_of(:serves) }

  it { should belong_to(:user) }
  it { should have_many(:ingredients).dependent(:destroy) }
  it { should have_many(:meals).dependent(:destroy) }

  # default_scope { order(:name) }
  describe ".all" do
    it "should be ordered by name" do
      z = FactoryGirl.create(:recipe, name: 'Z')
      a = FactoryGirl.create(:recipe, name: 'A')
      expect(Recipe.all).to contain_exactly(a, z)
    end
  end
end
