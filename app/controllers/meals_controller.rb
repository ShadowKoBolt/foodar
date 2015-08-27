class MealsController < ApplicationController
  before_action :set_meal, only: [:edit, :update, :destroy]

  # GET /meals
  # GET /meals.json
  def index
    @meals = current_user.meals.includes(:recipe)
    @meals_json = @meals
      .collect{ |meal| {
      title: meal.recipe.name,
      start: meal.date.strftime("%Y-%m-%d"),
      url: edit_meal_url(meal),
      className: meal.time
    } }.to_json
    @upcoming_meals = @meals.select{ |meal| meal.date >= Date.today }
  end

  # GET /meals/new
  def new
    @meal = Meal.new(date: params[:date])
  end

  # GET /meals/1/edit
  def edit
  end

  # POST /meals
  # POST /meals.json
  def create
    @meal = Meal.new(meal_params)

    respond_to do |format|
      if @meal.save
        format.html { redirect_to meals_url, notice: 'Meal was successfully created.' }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meals/1
  # PATCH/PUT /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to meals_url, notice: 'Meal was successfully updated.' }
        format.json { render :show, status: :ok, location: @meal }
      else
        format.html { render :edit }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1
  # DELETE /meals/1.json
  def destroy
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to meals_url, notice: 'Meal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicate
    @start_date = Date.commercial(Date.today.year, Date.today.cweek-1, 1)
    @end_date = Date.commercial(Date.today.year, Date.today.cweek-1, 7)
    @target_date = Date.commercial(Date.today.year, Date.today.cweek, 1)
  end

  def execute_duplicate
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    target_date = Date.parse(params[:target_date])
    meals = current_user
      .meals
      .where(["date >= ? AND date <= ?", start_date, end_date])
    ActiveRecord::Base.transaction do
      meals.each do |meal|
        offset = meal.date - start_date
        meal.dup.tap{ |m| m.date = (target_date + offset.days) }.save!
      end
    end
    redirect_to root_url,
      notice: t('notice.duplicated', model: Meal.model_name.human.pluralize)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = current_user.meals.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meal_params
      params
        .require(:meal)
        .permit(:recipe_id, :date, :time, :serves)
        .merge(user_id: current_user.id)
    end
end
