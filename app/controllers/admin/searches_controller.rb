class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]
    @search = params[:search]

    if @range == "ユーザー"
      @users = User.looks(@search, @word).page(params[:page])
    elsif @range == "得意先"
      @companies = Company.looks(@search, @word).page(params[:page])
    elsif @range == "プロジェクト"
      @projects = Project.looks(@search, @word).page(params[:page])
    elsif @range == "タグ"
      tags = Tag.looks(@search, @word)
      # タグに関連する全てのプロジェクトのIDを取得する
      project_ids = tags.inject([]) do |result, tag|
        result + tag.projects.pluck(:id)
      end
      # プロジェクトのIDを元にプロジェクトを取得し、ページネーションを適用させる
      # プロジェクトのIDは重複しないようにする
      @projects = Project.where(id: project_ids.uniq).page(params[:page])
    elsif @range == "グループ"
      @groups = Group.looks(@search, @word).page(params[:page])
    end
  end

end
