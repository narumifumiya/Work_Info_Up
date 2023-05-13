class Public::OfficesController < ApplicationController
  before_action :authenticate_user!

  def index
    @company = Company.find(params[:company_id])

    if params[:latest] #新しい順
      @offices = @company.offices.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @offices = @company.offices.old.page(params[:page])
    else
      @offices = @company.offices.page(params[:page])
    end
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
      redirect_to company_offices_path(@company), notice: "事業所を追加しました"
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
      redirect_to company_offices_path(@company), notice: "事業所情報を更新しました"
    else
      redirect_to request.referer, alert: "事業所名が入力されていません"
    end
  end

  def destroy
    @company = Company.find(params[:company_id])
    @office = Office.find(params[:id])
    @office.destroy
    redirect_to request.referer, alert: "事業所を削除しました"
  end

  private

  def office_params
    params.require(:office).permit(:name, :post_code, :address, :phone_number)
  end

end
