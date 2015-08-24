class Food < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :unit_name, presence: true

  attr_accessor :recipe_id

  def name_unit
    "#{name} (#{unit_name})"
  end

  def self.aisle_options
    %w( fruit vegatables fresh meat cooked_meat seafood canned_goods cupboard_basics fridge treats household_goods )
  end
end
