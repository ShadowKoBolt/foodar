class Meal < ActiveRecord::Base
  validates :recipe, :date, :user, presence: true
  validates :time, presence: true
  validates :serves, presence: true, numericality: true

  belongs_to :recipe
  belongs_to :user

  def self.time_options
    %w( breakfast lunch dinner snack )
  end

  def self.time_colour(time)
    case time
    when 'breakfast'
      'green'
    when 'lunch'
      'blue'
    when 'dinner'
      'red'
    when 'snack'
      'yellow'
    end
  end

end
