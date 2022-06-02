class UsersController < ApplicationController
  include Common
  require "json"

  def new
    unless @current_user
      render :layout => 'users/application'
      @user = User.new(flash[:user])
      return
    end
    redirect_to settings_path
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

  def settings
    # arr = [0, 6]
    # regularly_closed_day(arr, Date.today).to_s
  end


  private

  def user_params
    params.require(:user).permit(:name, :mail, :password, :password_confirmation)
  end

end
