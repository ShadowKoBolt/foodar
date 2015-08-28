class Ingredient < ActiveRecord::Base
  validates :food, :recipe, :amount, presence: true

  belongs_to :food
  belongs_to :recipe

  def amount_per_serving
    amount / recipe.serves
  end
end
