class Public::HomesController < ApplicationController
  def top
    @users = User.all.order(created_at: :desc).limit(6)
    @companies = Company.all.order(created_at: :desc).limit(6)
    @projects = Project.all.order(created_at: :desc).limit(6)
  end
  
  def login_top
    @users = User.all.order(created_at: :desc).limit(6)
    @companies = Company.all.order(created_at: :desc).limit(6)
    @projects = Project.all.order(created_at: :desc).limit(6)
  end
  
end
