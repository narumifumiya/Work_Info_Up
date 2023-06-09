class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.where('not visitor_id = ? OR action = ?', current_user.id, 'join').page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy_all
		@notifications = current_user.passive_notifications.destroy_all
		redirect_to notifications_path
  end

end
