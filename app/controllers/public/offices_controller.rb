class Public::OfficesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @company = Company.find(params[:company_id])
    @offices = @company.offices
  end

  def new
    @company = Company.find(params[:company_id])
    @office = Office.new
  end

  def create
    @company = Company.find(params[:company_id])
    @office = Office.new(office_params)
    @office.company_id = @company.id
    if @office.save
      flash[:notice] = "事業所を追加しました"
      redirect_to company_offices_path(@company)
    else
      @company = Company.find(params[:company_id])
      render :new
    end
  end

  def edit
    @company = Company.find(params[:company_id])
    @office = Office.find(params[:id])
  end

  def update
    @company = Company.find(params[:company_id])
    @office = Office.find(params[:id])
    if @office.update(office_params)
      flash[:notice] = "事業所情報を更新しました"
      redirect_to company_offices_path(@company)
    else
      @company = Company.find(params[:company_id])
      render :edit
    end
  end

  def destroy
    @company = Company.find(params[:company_id])
    @office = Office.find(params[:id])
    @office.destroy
    flash[:alert] = "事業所を削除しました"
    redirect_to request.referer
  end

  private

  def office_params
    params.require(:office).permit(:name, :post_code, :address, :phone_number)
  end

end
