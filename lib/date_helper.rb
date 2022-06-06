require 'date'

class Date
  %w[sunday monday tuesday wednesday thursday friday saturday].each{ |day|
    define_method("#{day}s") { days { |date| date.send("#{day}?".to_sym) } }
  }
  def days
    firstday = self.firstday
    lastday = self.lastday
    results = []
    firstday.upto(lastday) {|date|
      results << date if yield date
    }
    results
  end
  def firstday
    Date.new(self.year, self.month, 1)
  end
  def lastday
    next_month = self >> 1
    next_month_first_day = next_month.firstday
    next_month_first_day - 1
  end
end