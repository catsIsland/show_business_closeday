class CloseDaysController < ApplicationController
  include Common
  require "json"

  before_action :check_account_id, only: [:data :weekly_data]

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
    # 今月データ取得
    this_month_data(@account_id)

    # 翌月データ取得
    next_month_data(@account_id)

    # 設定データ取得
    setting_file_data(@account_id)

    data = { result: true, setting: @setting_file_data, this_month: @this_month_data, next_month: @next_month_data }
    render json: data
  end

  def weekly_data

    data = { result: 1 }
    render json: data
  end

  private


  
end
