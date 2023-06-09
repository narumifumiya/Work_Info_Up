class Public::GroupUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @permit = Permit.find(params[:permit_id])
    @group_user = GroupUser.create(user_id: @permit.user_id, group_id: params[:group_id])
    user = User.find(@permit.user_id) #通知送信者（参加者）のユーザー情報を通知作成の引数に使用する為、保存しておく
    @permit.destroy #参加希望者リストから削除する
    @group.create_notification_join!(user) # 参加通知を作成
    redirect_to request.referer
  end

  def destroy
    # current_userIDを持ったgroup_userの中からさらに、group_idカラムのデータがグループ詳細ページと一緒のデータを探す。
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    redirect_to request.referer, alert: "グループを退出しました"
  end

end
