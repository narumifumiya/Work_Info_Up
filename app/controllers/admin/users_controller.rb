class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.all
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
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  private

  # ゲストユーザーを編集できなくする
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to admin_user_path(@user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  def user_params
    params.require(:user).permit(:name, :name_kana, :email, :phone_number, :position, :department_id, :profile_image, :is_deleted)
  end

end
