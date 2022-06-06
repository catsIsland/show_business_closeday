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
      session[:user_name] = user.name
      Setting.create(user_id: user.id)

      o = [('0'..'9'),('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      string = (0...25).map { o[rand(o.length)] }.join
      tag_name = "#{string}_#{user.id}"
      setting = Setting.find_by(user_id: user.id)
      setting.tag_name = tag_name
      setting.save
      save_js_tag(user.id, tag_name)

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

  def tag_url
    account_id = session[:user_id]
    setting = Setting.find_by(user_id: account_id)
    tag_url = '<script type="text/javascript" src="' + request.protocol + request.subdomain + request.domain + '/tag/' + setting.tag_name.to_s + '.js"></script>'
  end

  helper_method :week_day_numbers, :week_day_names, :get_dai_data, :tag_url

  private

  def user_params
    params.require(:user).permit(:name, :mail, :password, :password_confirmation)
  end

  def save_js_tag(account_id, tag_name)
    path = "#{Rails.public_path}/tag/#{tag_name}.js"
    tag = %[
      $.when(
        close_days_script = document.createElement('script'),
        close_days_script.type = 'text/javascript',
        close_days_script.src = "#{request.protocol}#{request.subdomain}#{request.domain}/js/close_days.js?" + Date.now(),
        close_days_script.charset = 'UTF-8',
        document.getElementsByTagName('body')[0].appendChild(close_days_script),
        close_days_css = '<link rel="stylesheet" rel="nofollow" href="#{request.protocol}#{request.subdomain}#{request.domain}/css/close_days.css?' + Date.now() + '" type="text/css">',
        $('head').append(close_days_css)
      ).done(function () {
        $(document).ready(function () {
          url = "#{request.protocol}#{request.subdomain}#{request.domain}/close_days";
          let close_days_fun_count = 0;
          let close_days_interval = setInterval(function () {
            if (typeof show_close_days_calendar == 'function') {
              show_close_days_calendar(#{account_id}, url);
              clearInterval(close_days_interval);
            }
            if (++close_days_fun_count > 1000) {
              clearInterval(close_days_interval);
            }
          }, 100);
        });
      });
          ]
    
    File.open(path, "w+") do |f|
      f.write(tag)
    end
  end

end
