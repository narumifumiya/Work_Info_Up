class Public::CustomersController < ApplicationController
  before_action :authenticate_user!

  def index
    @company = Company.find(params[:company_id])

    if params[:latest] #新しい順
      @customers = @company.customers.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @customers = @company.customers.old.page(params[:page])
    else
      @customers = @company.customers.page(params[:page])
    end
  end

  def new
    @company = Company.find(params[:company_id])
    @customer = Customer.new
  end

  def create
    @company = Company.find(params[:company_id])
    @customer = Customer.new(customer_params)
    @customer.company_id = @company.id
    if @customer.save
      flash[:notice] = "顧客を追加しました"
      redirect_to company_customer_path(@company, @customer)
    else
      @company = Company.find(params[:company_id])
      render :new
    end
  end

  def show
    @company = Company.find(params[:company_id])
    @customer = Customer.find(params[:id])
  end

  def edit
    @company = Company.find(params[:company_id])
    @customer = Customer.find(params[:id])
  end

  def update
    @company = Company.find(params[:company_id])
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:notice] = "顧客情報を更新しました"
      redirect_to company_customer_path(@company, @customer)
    else
      @company = Company.find(params[:company_id])
      render :edit
    end
  end

  def destroy
    @company = Company.find(params[:company_id])
    @customer = Customer.find(params[:id])
    @customer.destroy
    flash[:alert] = "顧客を削除しました"
    redirect_to company_customers_path(@company)
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :phone_number, :email, :position, :department, :customer_image)
  end

end
