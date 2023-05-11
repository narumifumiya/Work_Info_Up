module Public::NotificationsHelper
  
  def notification_form(notification)
	  @visitor = notification.visitor
	  @comment = nil
	  @visitor_comment = notification.project_comment_id
	  @project = Project.find_by(id: notification.project_id)
    @company = @project.company
	  #notification.actionがfavoriteかcommentか
	  case notification.action
	    when "favorite" then
	      tag.a(@visitor.name, href:public_user_path(@visitor))+"が"+tag.a("#{@project.name}", href:company_project_path(@company, notification.project_id))+"にいいねしました"
	    when "comment" then
	    	@comment = ProjectComment.find_by(id: @visitor_comment)
	    	@comment_content =@comment.comment
	    	tag.a(@visitor.name, href:public_user_path(@visitor))+"が"+tag.a("#{@project.name}", href:company_project_path(@company, notification.project_id))+"にコメントしました"
	  end
  end
  
  
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
	end
  
end
