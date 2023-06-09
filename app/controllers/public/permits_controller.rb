class Public::PermitsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    permit = current_user.permits.new(group_id: params[:group_id])
    permit.save
    redirect_to request.referer
  end
  
  def destroy
    permit = current_user.permits.find_by(group_id: params[:group_id])
    permit.destroy
    redirect_to request.referer
  end
  
end
