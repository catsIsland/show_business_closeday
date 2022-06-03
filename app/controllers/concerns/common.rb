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

  def regularly_closed_day(day_of_week_array, date)
    start_date = date
    end_date = date.end_of_month
    # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    result = (start_date..end_date).to_a.select {|k| day_of_week_array.include?(k.wday)}
    result.map {|res| res.strftime('%-d').to_i }
  end

  def weekly_file_path(account_id)
    "data/weekly/#{account_id}/weekly.csv"
  end
  def this_month_file_path(account_id)
    "data/close_days/#{account_id}/#{this_year}/#{this_month}.csv"
  end

  def next_month_file_path(account_id)
    "data/close_days/#{account_id}/#{this_next_year}/#{this_next_month}.csv"
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

  def setting_file_data(account_id)
    File.open(setting_file_path(account_id)) do |f|
      @setting_file_data = f.read
    end
  end
end