class Public::DepartmentsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @department = Department.find(params[:id])
    @users = @department.users
  end
end
