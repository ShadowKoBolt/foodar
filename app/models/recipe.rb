class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :meals, dependent: :destroy

  validates :user, presence: true
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :serves, numericality: { only_integer: true, min: 1, max: 100 }

  default_scope { order(:name) }
end
