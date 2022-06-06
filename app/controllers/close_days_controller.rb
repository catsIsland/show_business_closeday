class CloseDaysController < ApplicationController
  include Common
  require "json"

  before_action :check_account_id, only: [:data, :setting_detail, :other_close_days]

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
    setting_data = setting_data(@account_id)

    data = { result: true, setting: setting_data, this_month: this_month, next_month: next_month }
    render json: data
  end

  def setting_detail
    result = false
    weekly_days = params['weekly_close_days'].map(&:to_i).join(',')
    setting = Setting.find_by(user_id: @account_id)
    if setting.present?
      setting.weekly_days = weekly_days
      setting.publish = params['publish']
      setting.element_id_flag = params['element_id_flag']
      setting.element_name = params['element_name']
      setting.background_color = params['background_color']
      setting.font_color = params['font_color']
      setting.title = params['title']
    else
      Setting.new(
        user_id: @account_id,
        weekly_days: weekly_days,
        publish: params['publish'],
        element_id_flag: params['element_id_flag'],
        element_name: params['element_name'],
        background_color: params['background_color'],
        font_color: params['font_color'],
        title: params['title']
      )
    end

    dai_number_close_day = DaiNumberCloseDay.where(user_id: @account_id)
    dai_number_close_day.destroy_all if dai_number_close_day.present?
   
    if !params['dai_count'].blank?
      params['dai_count'].each do |num|
        DaiNumberCloseDay.create(user_id: @account_id, dai_week_number: num, dai_close_day_number: params["dai_#{num}"].map(&:to_i).join(','))
      end
    end

    result = setting.save ? true : false

    data = { result: result }
    render json: data
  end

  def other_close_days
    this_month_close_days =  params['this_month_close_days'].map(&:to_i).join(',')
    next_month_close_days = params['next_month_close_days'].map(&:to_i).join(',')
    
    setting = Setting.find_by(user_id: @account_id)
    if setting.present?
      setting.others_close_days = this_month_close_days
      setting.next_month_others_close_days = next_month_close_days
    else
      Setting.new(user_id: @account_id, others_close_days: this_month_close_days, next_month_others_close_days: this_month_close_days)
    end
    result = setting.save ? true : false

    data = { result: result }
    render json: data
  end
  private


  
end
