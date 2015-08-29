class FoodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  def index
    @foods = current_user.foods.includes(:recipes)
  end

  def show
  end

  def new
    params[:food] ||= { x: 1 }
    @food = Food.new(food_params)
  end

  def edit
  end

  def create
    @food = Food.new(food_params)
    if @food.save
      message = t("notice.created", model: Food.model_name.human)
      if @food.recipe_id.present?
        url = new_recipe_ingredient_url(recipe_id: @food.recipe_id,
                                        ingredient: { food_id: @food.id })
        redirect_to url, notice: message
      else
        redirect_to foods_url, notice: message
      end
    else
      render :new
    end
  end

  def update
    if @food.update(food_params)
      redirect_to foods_url, notice: "Food was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @food.destroy
    redirect_to foods_url, notice: "Food was successfully destroyed."
  end

  private

  def set_food
    @food = current_user.foods.find(params[:id])
  end

  def food_params
    params.
      require(:food).
      permit(:name, :unit_name, :aisle, :recipe_id).
      merge(user_id: current_user.id)
  end
end
