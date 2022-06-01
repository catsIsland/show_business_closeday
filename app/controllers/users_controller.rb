class UsersController < ApplicationController

  def new
    render :layout => 'users/application'
    @user = User.new(flash[:user])
  end

  def create
    render :layout => 'users/application'

    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to settings_path
    else
      redirect_to :back, flash: {
        user: user,
        error_messages: user.errors.full_messages
      }
    end
  end

  def me
    
  end


  private

  def user_params
    params.require(:user).permit(:name, :mail, :password, :password_confirmation)
  end
end
