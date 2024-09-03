class ShiftsController < ApplicationController
  def index
    Rails.logger.debug "Calling set_month_data in ShiftsController#index"
    set_month_data(params[:year], params[:month])
    
    # current_userに関連する従業員を取得
    @employees = current_user.employees

    # current_userに関連するシフトデータを取得
    @shifts = Shift.where(employee_id: @employees.pluck(:id)).group_by(&:employee_id)

    # current_userに関連するメモを取得
    @memos = Memo.where(date: @start_date..@end_date, user_id: current_user.id).index_by(&:date)
    
    @shift_counts = sum_shift_counts(@employees, @shifts, @calendar)
  end

  def new
  end

  def create
  end
end
