class Public::ProjectCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    @comment = current_user.project_comments.new(project_comment_params)
    @comment.project_id = @project.id
    unless @comment.save
      render 'error'
    end
  end

  def destroy
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    ProjectComment.find(params[:id]).destroy
  end

  private

  def project_comment_params
    params.require(:project_comment).permit(:comment)
  end

end
