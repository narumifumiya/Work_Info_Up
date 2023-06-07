class Public::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:new, :create, :edit, :update]

  def index
    @user = User.find(params[:user_id])
    @tasks = @user.tasks
  end

  def show
    @user = User.find(params[:user_id])
    @task = Task.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @task = Task.new
  end

  def edit
    @user = User.find(params[:user_id])
    @task = Task.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to public_user_task_path(@user.id, @task), notice: 'スケジュールを更新しました'
    else
      @user = User.find(params[:user_id])
      render :edit
    end
  end

  def create
    @user = User.find(params[:user_id])
    @task = @user.tasks.new(task_params)
    if @task.save
      redirect_to public_user_tasks_path(@user.id), notice: 'スケジュールを作成しました'
    else
      @user = User.find(params[:user_id])
      render :new
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to public_user_tasks_path(current_user.id)
  end

  private

  def task_params
    params.require(:task).permit(:start_time,:title, :content)
  end

  def is_matching_login_user
    user_id = params[:user_id].to_i
    unless user_id == current_user.id
      redirect_to public_user_tasks_path(user_id), alert: "ログインユーザー以外のスケジュールの作成、編集はできません"
    end
  end

end
