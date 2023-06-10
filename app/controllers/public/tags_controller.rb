class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @tag = Tag.find(params[:id])
    if params[:latest] #新しい順
      @projects = @tag.projects.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @projects = @tag.projects.old.page(params[:page])
    else
      @projects = @tag.projects.page(params[:page])
    end
  end
  
end
