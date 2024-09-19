class Employee < ApplicationRecord
  validates :name, presence: true
  # 正社員、パート、派遣のいずれかであることを検証
  validates :employee_type, inclusion: { in: %w[正社員 パート 派遣] }
  validate :at_least_one_shift_selected

  belongs_to :user
  has_many :shifts, dependent: :destroy
  has_many :shift_requests, dependent: :destroy

  # 新規作成時にpositionを設定
  before_create :set_initial_position

   # スタッフを上に移動するメソッド
   def move_up
    above_employee = user.employees.where("position < ?", position).order(position: :desc).first
    return false if above_employee.nil?

    Employee.transaction do
      self.update!(position: above_employee.position)
      above_employee.update!(position: above_employee.position + 1)
    end
    true
  rescue
    false
  end

  # スタッフを下に移動するメソッド
  def move_down
    below_employee = user.employees.where("position > ?", position).order(position: :asc).first
    return false if below_employee.nil?

    Employee.transaction do
      self.update!(position: below_employee.position)
      below_employee.update!(position: below_employee.position - 1)
    end
    true
  rescue
    false
  end
  
  private

  def at_least_one_shift_selected
    unless early_shift || day_shift || late_shift || night_shift
      errors.add(:base, "1つ以上シフトを選択してください")
    end
  end

  def set_initial_position
    max_position = Employee.maximum(:position) || 0
    self.position = max_position + 1
  end
end
