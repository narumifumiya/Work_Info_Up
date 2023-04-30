class Admin::ProjectCommentsController < ApplicationController
  
  def destroy
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    ProjectComment.find(params[:id]).destroy
    # redirect_to request.referer
  end
  
  def destroy_all
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    @project_comments = @project.project_comments
    @project_comments.destroy_all
    redirect_to request.referer
  end
end
