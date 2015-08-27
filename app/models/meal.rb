class Meal < ActiveRecord::Base
  validates :recipe, :date, :user, presence: true
  validates :time, presence: true
  validates :serves, presence: true, numericality: true

  belongs_to :recipe
  belongs_to :user

  default_scope { order(date: :desc) }

  TIMES = %w( breakfast lunch dinner snack )

  def time_position
    TIMES.rindex(time)
  end

end
