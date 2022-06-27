class ApplicationController < ActionController::Base
    before_action :set_current_user
    before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
   
    def set_current_user
        @current_user = User.find_by(id: session[:user_id])
    end

    def authenticate_user
        if @current_user == nil
          flash[:notice] = "ログインが必要です"
          redirect_to("/login")
        end
    end

    def forbid_login_user
        if @current_user
          flash[:notice] = "すでにログインしています"
          redirect_to("/posts/index")
        end
    end

    def ensure_correct_user
      @post = Post.find_by(id: params[:id])
      if @post.user_id != @current_user.id
        flash[:notice] = "権限がありません"
        redirect_to("/posts/index")
      end
    end
end
