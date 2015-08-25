class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, only: [:dashboard]

  def home

  end

  def dashboard
    @meals_json = current_user
      .meals
      .collect{ |meal| {
      title: meal.recipe.name,
      start: meal.date.strftime("%Y-%m-%d"),
      url: edit_meal_url(meal),
      color: Meal.time_colour(meal.time)
    } }.to_json
  end

end
