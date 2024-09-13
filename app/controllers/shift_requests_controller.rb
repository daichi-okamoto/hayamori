class ShiftRequestsController < ApplicationController
  before_action :set_common_data, only: [:new, :create, :edit, :update]

  def new
    @shift_request = ShiftRequest.new
  end

  def create
    shift_requests_params = params[:shift_request][:shift_requests]&.to_unsafe_h || {}
    memos_params = params[:shift_request][:memos]&.to_unsafe_h || {}
  
    ActiveRecord::Base.transaction do
      shift_requests_params.each do |employee_id, shifts|
        shifts.each do |date, shift_type|
          next if shift_type.blank?
  
          ShiftRequest.create!(
            employee_id: employee_id,
            date: Date.parse(date),
            shift_type: format_shift_type(shift_type),
            user: current_user
          )
        end
      end
  
      memos_params.each do |date, content|
        next if content.blank?
  
        Memo.create!(
          user: current_user,
          date: Date.parse(date),
          content: content
        )
      end
    end
  
    flash[:success] = '勤務希望を保存しました'
    redirect_to new_shift_path(year: params[:shift_request][:year], month: params[:shift_request][:month])
  rescue ActiveRecord::RecordInvalid => e
    flash[:danger] = '勤務希望の保存に失敗しました'
    render :new, status: :unprocessable_entity
  end

  def edit
    @year = params[:year]
    @month = params[:month]
  
    # 勤務希望が既に存在するか確認し、なければ新規作成する
    @shift_request = ShiftRequest.find_or_initialize_by(year: @year, month: @month, employee_id: current_employee.id)

    if @shift_request.new_record?
      # 新しいシフトリクエストを保存
      @shift_request.save!
    end
  end

  def update
    shift_requests_params = params[:shift_request][:shift_requests]&.to_unsafe_h || {}
    memos_params = params[:shift_request][:memos]&.to_unsafe_h || {}

    ActiveRecord::Base.transaction do
      # 既存の勤務希望を更新する
      shift_requests_params.each do |employee_id, shifts|
        shifts.each do |date, shift_type|
          shift_request = ShiftRequest.find_by(user: current_user, employee_id: employee_id, date: Date.parse(date))
          
          if shift_request
            if shift_type.blank?
              shift_request.destroy
            else
              shift_request.update!(
                shift_type: format_shift_type(shift_type)
              )
            end
          elsif shift_type.present?
            ShiftRequest.create!(
              employee_id: employee_id,
              date: Date.parse(date),
              shift_type: format_shift_type(shift_type),
              user: current_user
            )
          end
        end
      end

      # 既存のメモを更新する
      memos_params.each do |date, content|
        memo = Memo.find_or_initialize_by(user: current_user, date: Date.parse(date))
        
        if content.blank?
          memo.destroy if memo.persisted?
        else
          memo.update!(content: content)
        end
      end
    end

    flash[:success] = '勤務希望を保存しました'
    redirect_to new_shift_path(year: params[:shift_request][:year], month: params[:shift_request][:month])
  rescue ActiveRecord::RecordInvalid => e
    flash[:danger] = '勤務希望の保存に失敗しました'
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @shift_request = current_user.shift_requests.find(params[:id])
    @shift_request.destroy
    redirect_to shift_requests_path
  end

  private

  def shift_request_params
    params.require(:shift_request).permit(:year, :month, memos: {}, shift_requests: {})
  end

  def format_shift_type(shift_type)
    case shift_type
    when 'H' then '早番'
    when 'N' then '日勤'
    when 'O' then '遅番'
    when 'Y' then '夜勤'
    when '⚫️' then '休み'
    else shift_type
    end
  end

  def set_common_data
    year = params[:year] || params.dig(:shift_request, :year)
    month = params[:month] || params.dig(:shift_request, :month)
    set_month_data(year, month)
    Rails.logger.debug "Year: #{year}, Month: #{month}, Start Date: #{@start_date}, End Date: #{@end_date}"
  
    @employees = current_user.employees
    @shifts = current_user.shifts.group_by(&:employee_id)
    @shift_requests = current_user.shift_requests.where(date: @start_date..@end_date)
    @memos = current_user.memos.where(date: @start_date..@end_date).index_by(&:date)
  end
end