class ShiftsController < ApplicationController
  def index
    Rails.logger.debug "Calling set_month_data in ShiftsController#index"
    set_month_data(params[:year], params[:month])
    
    @employees = current_user.employees
    # @shifts = Shift.where(employee_id: @employees.pluck(:id)).group_by(&:employee_id)
    # @memos = Memo.where(date: @start_date..@end_date, user_id: current_user.id).index_by(&:date)
    # @shift_counts = sum_shift_counts(@employees, @shifts, @calendar)
  end

  def new
  end

  def create
  end
end
