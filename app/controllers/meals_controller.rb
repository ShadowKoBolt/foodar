class MealsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal, only: [:edit, :update, :destroy]

  def index
    @meals = current_user.meals.includes(:recipe)
    @meals_json = @meals.
                  sort_by(&:time_position).
                  map do |meal|
      {
        title: "(#{meal.time.humanize[0]}) #{meal.recipe.name}",
        start: meal.date.strftime("%Y-%m-%d"),
        url: edit_meal_url(meal),
        className: meal.time
      }
    end.to_json
  end

  def new
    @meal = Meal.new(date: params[:date])
  end

  def edit
  end

  def create
    @meal = Meal.new(meal_params)
    if @meal.save
      redirect_to meals_url, notice: "Meal was successfully created."
    else
      render :new
    end
  end

  def update
    if @meal.update(meal_params)
      redirect_to meals_url, notice: "Meal was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @meal.destroy
    redirect_to meals_url, notice: "Meal was successfully destroyed."
  end

  def duplicate
    @start_date = Date.commercial(Date.today.year, Date.today.cweek - 1, 1)
    @end_date = Date.commercial(Date.today.year, Date.today.cweek - 1, 7)
    @target_date = Date.commercial(Date.today.year, Date.today.cweek, 1)
  end

  def execute_duplicate
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    target_date = Date.parse(params[:target_date])
    # TODO validation
    meals = current_user.
            meals.
            where(["date >= ? AND date <= ?", start_date, end_date])
    ActiveRecord::Base.transaction do
      meals.each do |meal|
        offset = meal.date - start_date
        meal.dup.tap { |m| m.date = (target_date + offset.days) }.save!
      end
    end
    redirect_to meals_url,
                notice: t("notice.duplicated", model: Meal.model_name.human.pluralize)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meal
    @meal = current_user.meals.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def meal_params
    params.
      require(:meal).
      permit(:recipe_id, :date, :time, :serves).
      merge(user_id: current_user.id)
  end
end
