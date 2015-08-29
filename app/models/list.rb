class List < ActiveRecord::Base
  validates :user, :name, :start_date, :end_date, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validate :start_date_before_end_date

  belongs_to :user

  private

  def start_date_before_end_date
    if (start_date && end_date) && (start_date > end_date)
      errors.add(:start_date,
                 "must be before #{List.human_attribute_name(:end_date)}")
    end
  end
end
