require 'rails_helper'

RSpec.describe Ingredient, type: :model do

  it { should validate_presence_of(:food) }
  it { should validate_presence_of(:recipe) }
  it { should validate_presence_of(:amount) }

  it { should belong_to(:food) }
  it { should belong_to(:recipe) }

  describe '#amount_per_serving' do
    it 'should be the amount divided by the number the recipe serves' do
      recipe = FactoryGirl.build(:recipe, serves: 2)
      ingredient = FactoryGirl.build(:ingredient, recipe: recipe, amount: 2)
      expect(ingredient.amount_per_serving).to eq(1)
    end
  end

end
