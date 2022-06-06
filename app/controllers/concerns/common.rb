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

  def this_month_allof_close_days(account_id)
    setting = Setting.find_by(user_id: account_id)
    setting_weekly_days = setting.weekly_days.blank? ? [] : setting.weekly_days.split(',').map(&:to_i)

    this_month_dai_number_close_day, next_month_dai_number_close_day = date_of_dai_close_day(account_id)

    others_close_days = setting.others_close_days.blank? ? [] : setting.others_close_days.split(',').map(&:to_i)
    next_month_others_close_days = setting.next_month_others_close_days.blank? ? [] : setting.next_month_others_close_days.split(',').map(&:to_i)

    this_month_day_str = others_close_days.concat dates_of_weekly(setting_weekly_days, Date.today.beginning_of_month).concat this_month_dai_number_close_day
    next_month_data = dates_of_weekly(setting_weekly_days, Date.today.beginning_of_month.next_month).concat next_month_dai_number_close_day
    next_month_day_str = next_month_others_close_days.concat next_month_data

    return this_month_day_str, next_month_day_str
  end

  def setting_data(account_id)
    setting = Setting.find_by(user_id: account_id)
    data = {
      publish: setting.publish,
      element_id_flag: setting.element_id_flag,
      element_name: setting.element_name,
      background_color: setting.background_color,
      font_color: setting.font_color,
      title: setting.title
    }
    return data
  end

  def date_of_dai_close_day(account_id)
    dai_number_close_day = DaiNumberCloseDay.where(user_id: account_id)
    this_month_dai_number_close_day = []
    next_month_dai_number_close_day = []
    if dai_number_close_day
      dai_number_close_day.each do |data|
        dai_week_number = data['dai_week_number'].to_i
        dai_close_day_number = data['dai_close_day_number'].split(',').map(&:to_i)
        this_month_dai_number_close_day.concat get_dai_close_days(account_id, dai_close_day_number, dai_week_number, Date.today)
        next_month_dai_number_close_day.concat get_dai_close_days(account_id, dai_close_day_number, dai_week_number, Date.today.next_month)
      end
      this_month_dai_number_close_day = this_month_dai_number_close_day
      next_month_dai_number_close_day = next_month_dai_number_close_day
    end
    return this_month_dai_number_close_day, next_month_dai_number_close_day
  end

  def delete_all_file_data(account_id)
    FileUtils.rm_rf "data/close_days/#{account_id}/"
    FileUtils.rm_rf "data/setting/#{account_id}"
  end

  def get_dai_close_days(account_id, dai_close_day_number, dai_week_number, date)
    # 第1〜第５
    name_of_week_day = %w[sundays mondays tuesdays wednesdays thursdays fridays saturdays]
    # dai_close_day_number:曜日
    dai_week_number = dai_week_number - 1 # 配列のため-1する
    d = date.beginning_of_month
    arr = []
    dai_close_day_number.each do |num|
      arr.push d.send(name_of_week_day[num])[dai_week_number].strftime('%d').to_i
    end
    arr
  end

  private

end