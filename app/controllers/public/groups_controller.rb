class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    if params[:latest] #新しい順
      @groups = Group.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @groups = Group.old.page(params[:page])
    else
      @groups = Group.page(params[:page])
    end
    
    # @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users.page(params[:page])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    # ↓誰が作ったグループかを判断する為に必要。
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.owner_id == current_user.id
      @group.destroy
      flash[:notice] = "グループを削除しました"
      redirect_to groups_path
    else
      flash[:alert] = "グループ作成者のみ削除ができます"
      redirect_to request.referer
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  # params[:id]を持つ@groupのowner_idカラムのデータと自分のユーザーIDが一緒かどうかを確かめる。
  # 違う場合はグループ一覧ページへ遷移させる。（オーナー以外は編集できない）before_actionで使用する。
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end
