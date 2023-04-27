class Public::UsersController < ApplicationController
  # before_action :authenticate_user!

  def index
    @users = User.all
    @departments = Department.all
  end

   def show
     @user = User.find(params[:id])
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

  private

  def user_params
    params.require(:user).permit(:name, :name_kana, :email, :phone_number, :position, :department_id, :profile_image)
  end

end
