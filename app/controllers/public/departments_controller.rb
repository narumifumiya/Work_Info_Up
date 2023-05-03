class Public::DepartmentsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @department = Department.find(params[:id])
    
    if params[:latest] #新しい順
      @users = @department.users.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @users = @department.users.old.page(params[:page])
    else
      @users = @department.users.page(params[:page])
    end
    # @users = @department.users
  end
end
