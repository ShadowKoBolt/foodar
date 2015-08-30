require 'rails_helper'

RSpec.describe ListItem, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:list) }
  it { should validate_presence_of(:aisle) }

  it { should belong_to(:list) }
end
