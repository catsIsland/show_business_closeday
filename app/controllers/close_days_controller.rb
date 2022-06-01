class CloseDaysController < ApplicationController
  protect_from_forgery :except => [:data]
  include Common
  require "json"

  def data
    unless params[:account_id]
      data = { result: false }
      render json: data
      return
    end

    # 今月データ取得
    this_month_file_path = "data/close_days/#{1}/#{this_year}/#{this_month}.csv"
    File.open(this_month_file_path) do |f|
      @this_month_data = f.read.split(',').grep(/\d+/, &:to_i)
    end

    # 翌月データ取得
    next_month_file_path = "data/close_days/#{1}/#{this_next_year}/#{this_next_month}.csv"
    File.open(next_month_file_path) do |f|
      @next_month_data = f.read.split(',').grep(/\d+/, &:to_i)
    end

    # 設定データ取得
    setting_file_path = "data/setting/#{1}/setting.json"
    File.open(setting_file_path) do |f|
      @setting_file_data = f.read
    end

    data = { result: true, setting: @setting_file_data, this_month: @this_month_data, next_month: @next_month_data }
    render json: data
  end

  private


  
end
