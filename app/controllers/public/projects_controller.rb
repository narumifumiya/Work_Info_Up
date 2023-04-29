class Public::ProjectsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]


  def index
    @company = Company.find(params[:company_id])
    @projects = @company.projects
  end

  def new
    @company = Company.find(params[:company_id])
    @project = Project.new
  end

  def create
    @company = Company.find(params[:company_id])
    @project = Project.new(project_params)
    @project.company_id = @company.id
    @project.user_id = current_user.id
    if @project.save
      flash[:notice] = "プロジェクトを追加しました"
      redirect_to company_project_path(@company, @project)
    else
      @company = Company.find(params[:company_id])
      render :new
    end
  end

  def show
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:id])
    @project_comment = ProjectComment.new
  end



  def edit
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:id])
  end

  def update
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:id])
    if @project.update(project_params)
      flash[:notice] = "プロジェクト情報を更新しました"
      redirect_to company_project_path(@company, @project)
    else
      @company = Company.find(params[:company_id])
      render :edit
    end

  end

  private

  def project_params
    params.require(:project).permit(:name, :start_date, :end_date, :introduction, :contract_amount, :order_status, :progress_status, :project_image)
  end

  # @bookの持つuser_idがログインユーザーと違う場合、books_pathへ遷移する
  # before_actionにてedit,updateのみ使用
  def is_matching_login_user
    @company = Company.find(params[:company_id])
    @project = Project.find(params[:id])
    user_id = @project.user_id
    unless user_id == current_user.id
      redirect_to company_project_path(@company, @project)
    end
  end

end
