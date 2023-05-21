class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    # .where(is_deleted: 'false')にて退社済みユーザーは表示しない
    if params[:latest] #新しい順
      @users = User.where(is_deleted: 'false').latest.page(params[:page]).per(12)
    elsif params[:old] == true #古い順
      @users = User.where(is_deleted: 'false').old.page(params[:page]).per(12)
    else
      @users = User.where(is_deleted: 'false').page(params[:page]).per(12)
    end

    @departments = Department.all
  end

   def show
     @user = User.find(params[:id])
     @projects = @user.projects
   end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to public_user_path(@user), notice:  "メンバー情報を変更しました"
    else
      render :edit
    end
  end

  def favorites
    @user = User.find(params[:id])
    @favorites = @user.favorites.page(params[:page])
  end

  def users
  end

  private

  # ゲストユーザーを編集できなくする
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to public_user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  # userのparams[:id]とcurrent_user.idが違う場合、マイページに遷移する
  # before_actionにてedit,updateのみ使用
  def is_matching_login_user
    user_id = params[:id].to_i
    unless user_id == current_user.id
      redirect_to public_user_path(current_user.id), alert: "ログインユーザー以外は編集できません"
    end
  end

  def user_params
    params.require(:user).permit(:name, :name_kana, :email, :phone_number, :position, :department_id, :profile_image)
  end

end
