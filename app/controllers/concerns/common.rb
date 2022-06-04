module Common
  extend ActiveSupport::Concern

  def today
    Date.today.day
  end

  def this_year
    Date.today.year
  end

  def this_month
    Date.today.month
  end

  def this_next_year
    Date.today.month == 12 ? Date.today.next_year.year : this_year
  end

  def this_next_month
    Date.today.next_month.month
  end

  def dates_of_weekly(day_of_week_array, date)
    start_date = date
    end_date = date.end_of_month
    # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| day_of_week_array.include?(k.wday)}
    result.map {|res| res.strftime('%-d').to_i }
  end
  
  # 今月
  def make_this_month_file_path(account_id)
    path = "data/close_days/#{account_id}/#{this_year}/"
    make_directory_file(path, "#{path}/#{this_month}.csv")
  end

  def this_month_file_path(account_id)
    "data/close_days/#{account_id}/#{this_year}/#{this_month}.csv"
  end

  # 来月
  def make_next_month_file_path(account_id)
    path = "data/close_days/#{account_id}/#{this_next_year}/"
    make_directory_file(path, "#{path}/#{this_next_month}.csv")
  end

  def next_month_file_path(account_id)
    "data/close_days/#{account_id}/#{this_next_year}/#{this_next_month}.csv"
  end
  
  # 設定
  def make_setting_file_path(account_id)
    path = "data/setting/#{account_id}/"
    make_directory_file(path, "#{path}/setting.json")
  end

  def setting_file_path(account_id)
    "data/setting/#{account_id}/setting.json"
  end

  def this_month_data(account_id)
    File.open(this_month_file_path(account_id)) do |f|
      @this_month_data = f.read.split(',').grep(/\d+/, &:to_i)
    end
  end

  def next_month_data(account_id)
    File.open(next_month_file_path(account_id)) do |f|
      @next_month_data = f.read.split(',').grep(/\d+/, &:to_i)
    end
  end

  def this_month_allof_close_days(account_id)
    setting = Setting.find_by(user_id: account_id)
    setting_weekly_days = setting.weekly_days.blank? ? [] : setting.weekly_days.split(',').map(&:to_i)
    
    this_month_day_str = this_month_data(account_id).concat dates_of_weekly(setting_weekly_days, Date.today.beginning_of_month)
    next_month_data = setting.weekly_repeat ? dates_of_weekly(setting_weekly_days, Date.today.beginning_of_month.next_month) : []
    next_month_day_str = next_month_data(account_id).concat next_month_data

    return this_month_day_str, next_month_day_str
  end

  def setting_file_data(account_id)
    File.open(setting_file_path(account_id)) do |f|
      @setting_file_data = f.read
    end
  end

  def delete_all_file_data(account_id)
    FileUtils.rm_rf "data/close_days/#{account_id}/"
    FileUtils.rm_rf "data/setting/#{account_id}"
  end

  private
  
  def make_directory_file(path, file)
    FileUtils.mkdir_p path
    FileUtils.touch file
  end

end