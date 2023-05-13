class Admin::CompaniesController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:latest] #新しい順
      @companies = Company.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @companies = Company.old.page(params[:page])
    else
      @companies = Company.page(params[:page])
    end

    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to admin_company_path(@company), notice: "得意先を追加しました"
    else
      render :error
    end
  end

  def show
    @company = Company.find(params[:id])
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      redirect_to admin_company_path(@company), notice: "得意先情報を編集しました"
    else
      render :edit
    end
  end

  def destroy
    @company = Company.find(params[:id])
    if @company.destroy
      redirect_to admin_companies_path, alert: "得意先を削除しました"
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :company_image)
  end


end
