class Public::CompaniesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if params[:latest] #新しい順
      @companies = Company.latest.page(params[:page])
    elsif params[:old] == true #古い順
      @companies = Company.old.page(params[:page])
    else
      @companies = Company.page(params[:page])
    end
  end

  def show
    @company = Company.find(params[:id])
  end
  
end
