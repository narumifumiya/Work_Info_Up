class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :is_matching_login_user, only: [:edit, :update]


  def index
    @users = User.all
    @departments = Department.all
  end

   def show
     @user = User.find(params[:id])
     @projects = @user.projects
     @company = Company.find(params[:id])
   end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "メンバー情報を変更しました"
      redirect_to public_user_path(@user)
    else
      render :edit
    end
  end
  
  def favorites
    @user = User.find(params[:id])
    @favorites = @user.favorites
    @company = Company.find(params[:id])
  end

  private

  # params[:id]とcurrent_user.idが違う場合、マイページに遷移する
  # before_actionにてedit,updateのみ使用
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to public_user_path(current_user.id)
    end
  end

  def user_params
    params.require(:user).permit(:name, :name_kana, :email, :phone_number, :position, :department_id, :profile_image)
  end

end
