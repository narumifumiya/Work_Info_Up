class Public::CustomersController < ApplicationController
  def index
    @company = Company.find(params[:company_id])
    @customers = @company.customers
  end

  def show
  end

  def edit
  end
end
