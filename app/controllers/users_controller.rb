class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]


  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
    @books = Book.all
  end

  def edit
    @user = User.find(params[:id])
    @book = Book.new
  end

  def update
    Rails.logger.debug "Received request method: #{request.method}"
  
    if request.post?
      redirect_to user_path(@user), method: :patch
      return
    end
  
    @user = User.find(params[:id])
    @book = Book.new
    
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end
  
  
  
  
  

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end
  

  def ensure_correct_user
    if params[:id].present?
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end
  end
end
