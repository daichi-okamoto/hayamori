class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show edit update destroy move_up move_down]

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params.merge(user_id: current_user.id))
    if @employee.save
      flash[:success] = 'スタッフが登録されました'
      redirect_to dashboard_index_path
    else
      flash.now[:danger] = 'スタッフの登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end 

  def index
    @employees = current_user.employees
  end

  def show
    @employee = current_user.employees.find(params[:id])
  end

  def edit
    @employee = current_user.employees.find(params[:id])
  end

  def update
    @employee = current_user.employees.find(params[:id])
    if @employee.update(employee_params)
      flash[:success] = 'スタッフを更新しました'
      redirect_to dashboard_index_path
    else
      flash.now[:danger] = 'スタッフの更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end 
  
  def destroy
    @employee = current_user.employees.find(params[:id])
    @employee.destroy
    flash[:success] = 'スタッフを削除しました'
    redirect_to dashboard_index_path, status: :see_other
  end

  def move_up
    handle_move(direction: :up)
  end

  def move_down
    handle_move(direction: :down)
  end

  private

  def handle_move(direction:)
    success = direction == :up ? @employee.move_up : @employee.move_down

    @employees = current_user.employees.order(:position)
    @max_position = @employees.maximum(:position)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('employees_table', partial: 'dashboard/employees_table', locals: { employees: @employees, max_position: @max_position })
      end
    end
  rescue => e
    Rails.logger.error "Failed to #{direction} employee #{@employee.id}: #{e.message}"
    render :index
  end

  def set_employee
    @employee = current_user.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :employee_type, :early_shift, :day_shift, :late_shift, :night_shift)
  end
end