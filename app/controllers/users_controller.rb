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

  def week_day_numbers
    [0, 1, 2, 3, 4, 5, 6]
  end

  def week_day_names
    ['日', '月', '火', '水', '木', '金', '土']
  end

  def settings
    account_id = session[:user_id]
    # this_month_file_path(account_id)
    
    File.open(weekly_file_path(account_id)) do |f|
      @weekly_data = f.read.split(',').grep(/\d+/, &:to_i)
    end

    # arr = [0, 6]
    # regularly_closed_day(arr, Date.today).to_s
  end

  helper_method :week_day_numbers, :week_day_names

  private

  def user_params
    params.require(:user).permit(:name, :mail, :password, :password_confirmation)
  end

end
