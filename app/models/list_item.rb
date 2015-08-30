class ListItem < ActiveRecord::Base
  validates :name, :aisle, :list, presence: true

  belongs_to :list
end
