class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def index
    @user = User.find_by_id(params[:user_id])
  end

  def create
    @micropost  = current_user.microposts.build(params[:micropost])
    if @micropost.save
      respond_to do |format|
        format.html {
          redirect_to root_path
          flash[:success] = "Micropost created!"
        }
        format.js {
          flash.now[:success] = "Micropost created!"
        }
      end
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_back_or root_path }
      format.js
    end
  end

  private

  def authorized_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end
end
