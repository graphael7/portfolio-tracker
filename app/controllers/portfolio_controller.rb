class PortfolioController < ApplicationController

  def show
    @user = User.find(params[:id])
    @portfolio = @user.generate_portfolio
    render json: @portfolio
  end
end
