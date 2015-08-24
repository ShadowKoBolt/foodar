class List < ActiveRecord::Base
  belongs_to :user

  validates :user, :name, :start_date, :end_date, presence: true
end
