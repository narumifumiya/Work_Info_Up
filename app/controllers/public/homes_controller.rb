class Public::HomesController < ApplicationController
  def top
    # .where(is_deleted: 'false')にて退社済みユーザーは表示しない
    @users = User.where(is_deleted: 'false').order(created_at: :desc).limit(6)
    @companies = Company.order(created_at: :desc).limit(6)
    @projects = Project.order(created_at: :desc).limit(6)
  end
  
end
