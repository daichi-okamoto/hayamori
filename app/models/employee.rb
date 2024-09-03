class Employee < ApplicationRecord
  validates :name, presence: true

  # 正社員、パート、派遣のいずれかであることを検証
  validates :employee_type, inclusion: { in: %w[正社員 パート 派遣] }

  belongs_to :user

  validate :at_least_one_shift_selected
  
  private

  def at_least_one_shift_selected
    unless early_shift || day_shift || late_shift || night_shift
      errors.add(:base, "1つ以上シフトを選択してください")
    end
  end
end
