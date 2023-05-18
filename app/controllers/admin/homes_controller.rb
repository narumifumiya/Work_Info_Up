class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = User.all.order(created_at: :desc).limit(6)
    @companies = Company.all.order(created_at: :desc).limit(6)
    @projects = Project.all.order(created_at: :desc).limit(6)
  end
end
