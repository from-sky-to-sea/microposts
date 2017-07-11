class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @microposts = current_user.feed_microposts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メッセージの登校に失敗しました。'
      #redirect_to root_url
      render 'toppages/index'
    end
  end

  def destroy
    
    # ---課題対応
    # お気に入り投稿から削除
    
    current_user.delete_from_favorite(@micropost)
    # その後、削除する
    
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'
    # 
    if params[:controller] == 'microposts' && params[:action] == 'destroy'
      redirect_to root_url
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
  
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end
