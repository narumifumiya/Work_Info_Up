class Public::ProjectCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    comment = current_user.project_comments.new(project_comment_params)
    comment.project_id = @project.id
    comment.save
    # redirect_to request.referer
  end

  def destroy
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    ProjectComment.find(params[:id]).destroy
    # redirect_to request.referer
  end

  private

  def project_comment_params
    params.require(:project_comment).permit(:comment)
  end


end
