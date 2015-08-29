require "rails_helper"

RSpec.describe Meal, type: :model do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:recipe) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:time) }
  it { should validate_presence_of(:serves) }
  it { should validate_numericality_of(:serves) }

  it { should belong_to(:user) }
  it { should belong_to(:recipe) }

  describe ".all" do
    it "should be ordered by date" do
      b = FactoryGirl.create(:meal, date: 7.days.from_now)
      a = FactoryGirl.create(:meal, date: 1.days.from_now)
      expect(Meal.all).to contain_exactly(a, b)
    end
  end

  describe "::TIMES" do
    it "should be an array" do
      expect(Meal::TIMES).to be_kind_of(Array)
    end

    it "should contain only strings" do
      expect(Meal::TIMES.map(&:class).uniq).to eq([String])
    end
  end

  describe "#time_position" do
    meals = {
      "breakfast" => 0,
      "lunch" => 1,
      "dinner" => 2,
      "snack" => 3
    }
    meals.each do |k, v|
      it "should place #{k} in position #{v}" do
        expect(FactoryGirl.build(:meal, time: k).time_position).to eq(v)
      end
    end
  end
end
