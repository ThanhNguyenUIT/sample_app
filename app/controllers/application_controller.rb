class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.new.please_log_in"
      redirect_to login_url
    end
  end
end
