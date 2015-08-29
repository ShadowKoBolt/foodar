class IngredientsController < ApplicationController
  before_action :set_recipe
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]

  def new
    params[:ingredient] ||= { x: 1 }
    @ingredient = Ingredient.new(ingredient_params)
  end

  def edit
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      redirect_to @recipe, notice: "Ingredient was successfully created."
    else
      render :new
    end
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to @recipe, notice: "Ingredient was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to recipe_url(@recipe), notice: "Ingredient was successfully destroyed."
  end

  private

  def set_recipe
    @recipe = current_user.recipes.find(params[:recipe_id])
  end

  def set_ingredient
    @ingredient = @recipe.ingredients.find(params[:id])
  end

  def ingredient_params
    params.
      require(:ingredient).
      permit(:food_id, :amount).
      merge(recipe_id: @recipe.id)
  end
end
