class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @search = params[:search]

    if @range == "User"
      @users = User.looks(@search, @word)
    else
      @companies = Company.looks(@search, @word)
    end
  end

end
