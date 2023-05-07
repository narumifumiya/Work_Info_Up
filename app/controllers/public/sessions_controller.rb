# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]

  def after_sign_in_path_for(resource)
    public_user_path(current_user)
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to public_user_path(user), notice: 'ゲストユーザーでログインしました。'
  end

  protected

  # 退会しているかを判断するメソッド
  def user_state
    ## 【処理内容1】 入力されたemailからアカウントを1件取得
    @user = User.find_by(email: params[:user][:email])
    ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@user
    ## 【処理内容2】 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted == true
      ## 【処理内容3】
      flash[:alert] = "退社済みです"
      redirect_to new_user_registration_path
    end
  end

end
