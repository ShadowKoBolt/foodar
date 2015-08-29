class ListsController < ApplicationController
  class ShoppingListItem < Struct.new(:food, :amount)
  end

  before_action :set_list, only: [:show, :edit, :update, :destroy]

  # GET /lists
  # GET /lists.json
  def index
    @lists = current_user.lists
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    meals = current_user.
            meals.
            where(["date >= ? AND date <= ?", @list.start_date, @list.end_date])
    @shopping_list_items = []
    meals.each do |meal|
      meal.recipe.ingredients.each do |ingredient|
        item = @shopping_list_items.detect { |item| item.food == ingredient.food }
        adjustment = (meal.serves / meal.recipe.serves.to_f)
        amount = ingredient.amount * adjustment
        if item
          item.amount += amount
        else
          @shopping_list_items << ShoppingListItem.new(ingredient.food, amount)
        end
      end
    end
    @shopping_list_items = @shopping_list_items.group_by { |i| i.food.aisle }
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: "List was successfully updated." }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: "List was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = current_user.lists.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def list_params
    params.
      require(:list).
      permit(:start_date, :end_date, :name).
      merge(user_id: current_user.id)
  end
end
