class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @users = User.all
  end

  def create
    User.create!(email: params[:email])
    @users = User.all

    render json: { users: @users.to_json }
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }
  end
end
