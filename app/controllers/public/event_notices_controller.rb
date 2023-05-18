class Public::EventNoticesController < ApplicationController
  before_action :authenticate_user!
  before_action :join_group_user?

  def new
    # view/event_notices/new.html.erbのフォームでグループIDが必要な為
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(params[:group_id]) #newアクションと同じグループIDが入っている
    @title = params[:title] #フォームで入力された内容が入っている
    @body = params[:body] #フォームで入力された内容が入っている
    @image = params[:image]

    # 上記でインスタンス変数のデータを変数eventのハッシュとして登録
    event = {
      # キー.   データ
      :group => @group,
      :title => @title,
      :body => @body,
      :image => @image
      # enent[:group]で@groupを呼び出せるようになる（event_mailerで使う）
    }

    # app/mailers/event_mailer.rbコントローラ？のクラスメソッドを使用している
    EventMailer.send_notifications_to_group(event)

    # @group,@title,@bodyのデータを持ったまま、view/event_notices/sent.html.erbを表示する
    render :sent
  end

  def sent
    redirect_to group_path(params[:group_id])
  end

  private

  # グループに参加していないとチャットルームにはいけない
  def join_group_user?
    @group = Group.find(params[:group_id])
    @group_users = @group.group_users
    unless @group_users.exists?(user_id: current_user.id)
      redirect_to request.referer, alert: "グループに参加してください"
    end
  end

end
