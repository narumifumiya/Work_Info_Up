class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @search = params[:search]


    if @range == "ユーザー"
      @users = User.looks(@search, @word)
    elsif @range == "得意先"
      @companies = Company.looks(@search, @word)
    elsif @range == "プロジェクト"
      @projects = Project.looks(@search, @word)
    elsif @range == "タグ"
      @tags = Tag.looks(@search, @word)
    end
  end

end
