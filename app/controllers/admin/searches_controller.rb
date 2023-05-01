class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!
  
  def search
    @range = params[:range]
    @word = params[:word]
    @search = params[:search]


    if @range == "User"
      @users = User.looks(@search, @word)
    elsif @range == "Company"
      @companies = Company.looks(@search, @word)
    elsif @range == "Project"
      @projects = Project.looks(@search, @word)
    elsif @range == "Tag"
      @tags = Tag.looks(@search, @word)
    end
  end

end
