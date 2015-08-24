class Ingredient < ActiveRecord::Base
  belongs_to :food
  belongs_to :recipe

  validates :food, :recipe, :amount, presence: true

  def amount_per_serving
    amount / recipe.serves
  end
end
