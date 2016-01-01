class TimeBalance

  attr_accessor :hour, :minute

  def initialize
    reset
  end

  def calculate_balance(time_1, time_2)
    calculate(-(parsed_time(time_1)), parsed_time(time_2))
  end

  def positive?
    self.hour > 0 || self.minute > 0
  end

  def cleared?
    self.hour == 0 && self.minute == 0
  end

  def negative?
    !(cleared? || positive?)
  end

  def sum(balance)
    calculate((self.hour.hours + self.minute.minutes), (balance.hour.hours + balance.minute.minutes))

    self
  end

  def to_s
    '%02d:%02d' % [self.hour.abs, self.minute.abs]
  end

  def to_seconds
    (self.hour.abs.hours + self.minute.abs.minutes)
  end

  def reset
    self.hour = 0
    self.minute = 0
  end

  private

  def calculate(time_1, time_2)
    total = time_1 + time_2
    mm, _ss = total.divmod(60)

    self.hour, self.minute = mm.abs.divmod(60)

    if total < 0
      self.hour *= -1
      self.minute *= -1
    end

  end

  def parsed_time(time)
    return time if time.is_a?(Integer)
    time.hour.hours + time.min.minutes
  end

end
