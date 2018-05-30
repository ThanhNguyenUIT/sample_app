class SessionsController < ApplicationController
  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == Settings.remember_me.checked ?
                                          remember(@user) : forget(@user)
        redirect_back_or @user
      else
        flash[:warning] = t "sessions.new.not_activated"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "sessions.new.invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def new
  end
end
