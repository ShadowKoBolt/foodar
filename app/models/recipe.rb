class Recipe < ActiveRecord::Base
  validates :user, :serves, presence: true
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :serves, numericality: { min: 1, max: 100 }

  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :meals, dependent: :destroy

  default_scope { order(:name) }
end
