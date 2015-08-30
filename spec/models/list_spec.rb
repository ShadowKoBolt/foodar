require "rails_helper"

RSpec.describe List, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:list_items).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }

  describe "validations" do
    describe "start_date" do
      it "is invalid if after end_date" do
        list = FactoryGirl.build(:list,
                                 start_date: 3.days.from_now,
                                 end_date: Date.today)
        expect(list).to_not be_valid
      end
    end
  end
end
