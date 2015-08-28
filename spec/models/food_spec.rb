require "rails_helper"

RSpec.describe Food, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should validate_presence_of(:unit_name) }
  it { should validate_presence_of(:user) }

  it { should belong_to(:user) }
  it { should have_many(:ingredients) }
  it { should have_many(:recipes).through(:ingredients) }

  describe ".aisle_options" do
    subject { Food.aisle_options }
    it "should be an array" do
      expect(subject).to be_kind_of(Array)
    end
    it "should be made up of strings" do
      expect(subject.map { |item| item.class }.uniq).to eq([String])
    end
  end

  describe ".all" do
    it "should be ordered by name" do
      z = FactoryGirl.create(:food, name: "Z")
      a = FactoryGirl.create(:food, name: "A")
      expect(Food.all).to contain_exactly(a, z)
    end
  end

  describe "#name_unit" do
    subject do
      FactoryGirl.build(:food, name: "Foo", unit_name: "Bar").name_unit
    end
    it "should include the food name" do
      expect(subject).to include("Foo")
    end
    it "should include the food unit name" do
      expect(subject).to include("Bar")
    end
  end
end
