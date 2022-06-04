class UsersController < ApplicationController
  include Common
  require "json"
  require 'fileutils'

  def new
    @user = User.new(flash[:user])
    unless @current_user
      render :layout => 'users/application'
      return
    end
    redirect_to settings_path
  end

  def create
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

    # フォルダ作成
    make_folder(account_id)

    # 設定データ

    @setting = Setting.find_by(user_id: account_id)
    @setting_weekly_days = @setting.weekly_days.blank? ? [] : @setting.weekly_days.split(',').map(&:to_i)
    @setting_weekly_repeat = @setting.weekly_repeat
    # 定休日の日を取得
    @this_month_weekly_close_days = dates_of_weekly(@setting_weekly_days, Date.today.beginning_of_month)
    @next_month_weekly_close_days = @setting.weekly_repeat ? dates_of_weekly(@setting_weekly_days, Date.today.beginning_of_month.next_month) : []
  
    # 定休日以外
    this_month_data(account_id)
    next_month_data(account_id)
  
  end

  helper_method :week_day_numbers, :week_day_names

  private

  def user_params
    params.require(:user).permit(:name, :mail, :password, :password_confirmation)
  end

  def make_folder(account_id)
    make_this_month_file_path(account_id)
    make_this_month_file_path(account_id)
    make_next_month_file_path(account_id)
    make_setting_file_path(account_id)
    Setting.create(user_id: account_id)
  end

end
