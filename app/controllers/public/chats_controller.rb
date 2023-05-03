class Public::ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :join_group_user?

  def index
    @group = Group.find(params[:group_id])
    @chats = @group.chats
    @chat = Chat.new
  end

  def create
    @group = Group.find(params[:group_id])
    @chat = current_user.chats.new(chat_params)
    @chat.group_id = @group.id
    @chat.save
    redirect_to request.referer
  end

  def destroy
    @group = Group.find(params[:group_id])
    @chat= Chat.find_by(id: params[:id], user_id: current_user.id)
    @chat.destroy
    redirect_to request.referer
  end


  private

  def chat_params
    params.require(:chat).permit(:message)
  end

  # グループに参加していないとチャットルームにはいけない
  def join_group_user?
    @group = Group.find(params[:group_id])
    @group_users = @group.group_users
    unless @group_users.exists?(user_id: current_user.id)
        flash[:alert] = "グループに参加してください"
        redirect_to request.referer
    end
  end

end
