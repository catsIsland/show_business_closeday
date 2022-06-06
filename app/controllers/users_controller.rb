class UsersController < ApplicationController
  include Common
  require "json"
  require 'fileutils'
  require 'date_helper'

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
      Setting.create(user_id: user.id)
      redirect_to settings_path
    else
      redirect_back fallback_location: new_user_path, flash: {
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
    @dai_week_name = ["第-1", "第-2", "第-3", "第-4"]

    # 設定データ
    @setting = Setting.find_by(user_id: account_id)
    @setting_weekly_days = @setting.weekly_days.blank? ? [] : @setting.weekly_days.split(',').map(&:to_i)
    
    # 定休日の日を取得
    @this_month_weekly_close_days = dates_of_weekly(@setting_weekly_days, Date.today.beginning_of_month)
    @next_month_weekly_close_days = dates_of_weekly(@setting_weekly_days, Date.today.beginning_of_month.next_month)
  
    # 定休日以外
    @others_close_days = @setting.others_close_days
    @next_month_others_close_days = @setting.next_month_others_close_days

    # 第休取得
    @this_month_dai_number_close_day, @next_month_dai_number_close_day = date_of_dai_close_day(account_id)

  end

  def get_dai_data(dai_week_number)
    dai_number_close_day = DaiNumberCloseDay.find_by(user_id: session[:user_id], dai_week_number: dai_week_number)
    dai_number_close_day ? dai_number_close_day['dai_close_day_number'].split(',').map(&:to_i) : []
  end

  helper_method :week_day_numbers, :week_day_names, :get_dai_data

  private

  def date_from_week_and_day(number_of_week, number_of_week_day)
    # 当月の初日を出す
    d = Date.today.beginning_of_month
    
    # 初週の日数
    first_week = 7 - d.wday

    day = first_week + (7 * ( number_of_week - 2)) + number_of_week_day + 1 # 日曜始まりにするためにwday+1にする

    # その月に存在しない日になったらfalse
    return false if d.end_of_month.day < day || day < 1
    day
  end

  def user_params
    params.require(:user).permit(:name, :mail, :password, :password_confirmation)
  end

end
