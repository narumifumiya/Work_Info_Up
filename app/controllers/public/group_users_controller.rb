class Public::GroupUsersController < ApplicationController

  def create
    # current_userIDを持ったgroup_userを作成する。作成時にgroup_idカラムにグループ詳細ページのIDを保存する。
    group_user = current_user.group_users.new(group_id: params[:group_id])
    group_user.save
    redirect_to request.referer
  end

  def destroy
    # current_userIDを持ったgroup_userの中からさらに、group_idカラムのデータがグループ詳細ページと一緒のデータを探す。
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    redirect_to request.referer
  end

end
