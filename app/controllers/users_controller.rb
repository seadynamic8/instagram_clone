class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  def index
    if params[:search_query].present?
      @users = User.where("username LIKE ?", "%#{params[:search_query]}%")
        .and(User.where.not(id: current_user.id))
    else
      @users = []
    end

    respond_to do |format|
      format.turbo_stream do
        @partial_folder = 
          params[:search_target] == "search_user_results" ? "messages" : "layouts"
      end
    end
  end

  def show
    
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end