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
end