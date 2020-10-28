class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update]
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
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
        @articles = @user.articles
    end

    def index
        @users = User.all
    end




    private
   
    def set_user
        @user = User.find(params[:id])
    end


    def user_params
        params.required(:user).permit(:username, :email, :password)
    end


end
