class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:index, :show, :create]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Welcome to the Alpha Blog #{@user.username}, you're now signed up!"
            redirect_to articles_path
        else
            render 'new'
        end
    end

    def edit 
    end

    def update
        if @user.update(user_params)
            flash[:notice] = "Your user has been updated!"
            redirect_to @user
        else
            render 'edit'
        end
    end
    
    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end

    def index
        @users = User.paginate(page: params[:page], per_page: 5)
    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user
        flash[:notice] = "Account and all associated articles were deleted"
        redirect_to articles_path
    end



    private
   
    def set_user
        @user = User.find(params[:id])
    end


    def user_params
        params.required(:user).permit(:username, :email, :password)
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "Only the owner can do that!"
            redirect_to @user
        end
    end

end
