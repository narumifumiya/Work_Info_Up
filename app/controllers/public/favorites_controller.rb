class Public::FavoritesController < ApplicationController

  def create
    project = Project.find(params[:project_id])
    favorite = current_user.favorites.new(project_id: project.id)
    favorite.save
    redirect_to request.referer
  end

  def destroy
    project = Project.find(params[:project_id])
    favorite = current_user.favorites.find_by(project_id: project.id)
    favorite.destroy
    redirect_to request.referer
  end

end
