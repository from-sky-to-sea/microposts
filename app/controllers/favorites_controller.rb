class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    if logged_in?
      @user = current_user
      @microposts = current_user.favorite_microposts.order('created_at DESC').page(params[:page])
    end
  end
  
  def create
    post = Micropost.find(params[:favpost_id])
    current_user.add_to_favorite(post)
    flash[:success] = 'お気に入りに追加しました。'
    
    redirect_back(fallback_location: root_path)
  end

  def destroy
    post = Micropost.find(params[:favpost_id])
    current_user.delete_from_favorite(post)
    flash[:success] = 'お気に入りから削除しました。'
    
    #redirect_back(fallback_location: root_path)
    redirect_to root_url
  end
end
