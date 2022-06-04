class CloseDaysController < ApplicationController
  include Common
  require "json"

  before_action :check_account_id, only: [:data, :weekly_data, :other_close_days]

  protect_from_forgery :except => [:data]
  
  def check_account_id
    unless params[:account_id]
      data = { result: false }
      render json: data
      return
    end
    @account_id = params[:account_id]
  end

  def data
    this_month, next_month = this_month_allof_close_days(@account_id)
    # 設定データ取得
    setting_file_data(@account_id)

    data = { result: true, setting: @setting_file_data, this_month: this_month, next_month: next_month }
    render json: data
  end

  def weekly_data
    result = false
    weekly_days = params['weekly_close_days'].map(&:to_i).join(',')
    setting = Setting.find_by(user_id: @account_id)
    if setting.present?
      setting.weekly_days = weekly_days
      setting.weekly_repeat = params['repeat_weekly_days']
    else
      Setting.new(user_id: @account_id, weekly_days: weekly_days)
    end
    result = setting.save ? true : false

    data = { result: result }
    render json: data
  end

  def other_close_days
    this_month_close_days =  params['this_month_close_days'].map(&:to_i).join(',')
    next_month_close_days = params['next_month_close_days'].map(&:to_i).join(',')
    
    File.write(this_month_file_path(@account_id), this_month_close_days)
    File.write(next_month_file_path(@account_id), next_month_close_days)

    data = { result: 1 }
    render json: data
  end
  private


  
end
