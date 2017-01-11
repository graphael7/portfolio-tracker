class PortfolioController < ApplicationController

  def show
    user = User.find_by(authentication_token: params[:authentication_token])
    portfolio = user.generate_portfolio
    render json: portfolio
  end

  def history
    @user = User.find(params[:id])
    @history = @user.generate_portfolio_history
    render json: @history
  end
end
