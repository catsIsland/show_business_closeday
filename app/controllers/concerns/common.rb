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
end