class UsersController < ApplicationController
  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "layouts.application.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "shared.error_messages.couldnt_found", id: params[:id]
      redirect_to signup_path
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end
end
