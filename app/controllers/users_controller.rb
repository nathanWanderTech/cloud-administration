# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], per_page: params[:per_page] ||= 30).order(created_at: :desc)
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The user you're looking for cannot be found"
    respond_to do |format|
      format.html { redirect_to users_path }
      format.json { render json: nil, status: 404 }
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user, {})
  end
end
