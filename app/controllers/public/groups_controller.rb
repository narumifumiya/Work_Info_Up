class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:latest] #新しい順
      @groups = Group.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @groups = Group.old.page(params[:page])
    else
      @groups = Group.page(params[:page])
    end

    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users.page(params[:page]).per(12)
    # グループオーナのユーザー情報を取ってきている
    @group_owner = User.find_by(id: @group.owner_id)
  end

  def create
    @group = Group.new(group_params)
    # 誰が作ったグループかを判断する為に必要。
    @group.owner_id = current_user.id
    if @group.save
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      render :error
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "グループ情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path, notice: "グループを削除しました"
  end

  def permits
    @group = Group.find(params[:id])
    @permits = @group.permits.page(params[:page])
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  # params[:id]を持つ@groupのowner_idカラムのデータと自分のユーザーIDが一緒かどうかを確かめる。
  # 違う場合はグループ詳細ページを再表示させる。（オーナー以外は編集できない）before_actionで使用する。
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to group_path(@group), alert: "グループオーナーのみ編集が可能です"
    end
  end

end
