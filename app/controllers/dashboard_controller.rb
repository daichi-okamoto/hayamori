class DashboardController < ApplicationController
  def index
    @employees = current_user.employees.order(position: :asc)
  end
end
