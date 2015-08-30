class ListsController < ApplicationController
  class ShoppingListItem < Struct.new(:food,
                                      :name,
                                      :unit_name,
                                      :aisle,
                                      :amount,
                                      :edit_url)
  end

  before_action :authenticate_user!
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    @lists = current_user.lists
  end

  def show
    meals = current_user.
            meals.
            where(["date >= ? AND date <= ?", @list.start_date, @list.end_date])
    @shopping_list_items = []
    meals.each do |meal|
      meal.recipe.ingredients.each do |ingredient|
        item = @shopping_list_items.
          detect { |item| item.food == ingredient.food }
        adjustment = (meal.serves / meal.recipe.serves.to_f)
        amount = ingredient.amount * adjustment
        if item
          item.amount += amount
        else
          @shopping_list_items << ShoppingListItem.new(ingredient.food,
                                                       ingredient.food.name,
                                                       ingredient.food.unit_name,
                                                       ingredient.food.aisle,
                                                       amount,
                                                       nil)
        end
      end
    end
    @list.list_items.each do |list_item|
      @shopping_list_items << ShoppingListItem.new(nil,
                                                   list_item.name,
                                                   nil,
                                                   list_item.aisle,
                                                   nil,
                                                   edit_list_list_item_url(@list, list_item))

    end
    @shopping_list_items = @shopping_list_items.group_by { |i| i.aisle }
  end

  def new
    @list = List.new
  end

  def edit
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to @list, notice: "List was successfully created."
    else
      render :new
    end
  end

  def update
    if @list.update(list_params)
      redirect_to @list, notice: "List was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to lists_url, notice: "List was successfully destroyed."
  end

  private

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.
      require(:list).
      permit(:start_date, :end_date, :name).
      merge(user_id: current_user.id)
  end
end
