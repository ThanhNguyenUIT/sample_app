class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @relationship = current_user.active_relationships.find_by followed_id: @user.id
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "shared.error_messages.couldnt_found", id: params[:followed_id]
      redirect_to users_path
    end
  end

  def destroy
    relationship = Relationship.find_by id: params[:id]
    if relationship
      @user = relationship.followed
      current_user.unfollow @user
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "shared.error_messages.relationship_not_found"
      redirect_to users_path
    end
  end
end
