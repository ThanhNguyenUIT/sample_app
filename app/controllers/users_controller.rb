class UsersController < ApplicationController
  before_action :logged_in_user, except: [:create, :new, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, except: [:create, :index, :new]

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.new.check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.index.user_delete"
    else
      flash[:danger] = t "shared.error_messages.delete_failed"
    end
    redirect_to users_url
  end

  def edit
  end

  def index
    @users = User.activated.paginate page: params[:page]
  end

  def following
    @title = t "users.following"
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t "users.followers"
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end

  def new
    @user = User.new
  end

  def show
    redirect_to root_url unless @user.activated?
    @microposts = @user.microposts.order_desc.paginate page: params[:page]
    @relationship = current_user.active_relationships.find_by followed_id: @user.id
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.edit.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    load_user
    redirect_to root_url unless current_user? @user
  end

  def load_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t "shared.error_messages.couldnt_found", id: params[:id]
    redirect_to users_url
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end
end
