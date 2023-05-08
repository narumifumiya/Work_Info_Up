class Admin::DepartmentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:latest] #新しい順
      @departments = Department.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @departments = Department.old.page(params[:page])
    else
      @departments = Department.page(params[:page])
    end

    @department = Department.new
  end

  def show
    @department = Department.find(params[:id])

    if params[:latest] #新しい順
      @users = @department.users.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @users = @department.users.old.page(params[:page])
    else
      @users = @department.users.page(params[:page])
    end
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      flash[:notice] = "部署の登録が成功しました"
      redirect_to request.referer
    else
      flash[:alert] = "部署名が入力されていません"
      redirect_to request.referer
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update(department_params)
      flash[:notice] = "部署名を変更しました"
      redirect_to admin_departments_path
    else
      render :edit
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    flash[:alert] = "部署を削除しました"
    redirect_to request.referer
  end

  private

  def department_params
    params.require(:department).permit(:name)
  end

end
