class Public::DepartmentsController < ApplicationController
  def show
    @department = Department.find(params[:id])
    @users = @department.users
  end
end
