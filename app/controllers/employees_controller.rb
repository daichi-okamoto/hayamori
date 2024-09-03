class EmployeesController < ApplicationController
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

  private

  def employee_params
    params.require(:employee).permit(:name, :employee_type, :early_shift, :day_shift, :late_shift, :night_shift)
  end
end