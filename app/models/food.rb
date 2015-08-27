class Food < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :recipes, through: :ingredients

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :unit_name, presence: true

  attr_accessor :recipe_id

  default_scope { order(:name) }

  def name_unit
    "#{name} (#{unit_name})"
  end

  def self.aisle_options
    %w( fruit vegatables dairy fresh_meat cooked_meat seafood canned_goods cupboard_basics fridge bakery cereal treats household_goods ).sort
  end
end
