class Admin::ProjectCommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def destroy
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    ProjectComment.find(params[:id]).destroy
  end
  
  def destroy_all
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:project_id])
    @project_comments = @project.project_comments
    @project_comments.destroy_all
    redirect_to request.referer
  end
end
