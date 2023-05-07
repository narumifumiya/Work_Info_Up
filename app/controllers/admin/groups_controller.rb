class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
  
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

  def destroy
    group = Group.find(params[:id])
    group.destroy
    flash[:alert] = "グループを削除しました"
    redirect_to admin_groups_path
  end
end
