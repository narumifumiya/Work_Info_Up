class Public::DepartmentsController < ApplicationController
  before_action :authenticate_user!

  def show
    @department = Department.find(params[:id])
    @departments = Department.all

    if params[:latest] #新しい順
      @users = @department.users.latest.page(params[:page]).per(12)
    elsif params[:old] == true #古い順
      @users = @department.users.old.page(params[:page]).per(12)
    else
      @users = @department.users.page(params[:page]).per(12)
    end
  end

end
