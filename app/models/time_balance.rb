class TimeBalance

  BASE_TIME = Time.zone.local(1999, 8, 1)

  attr_accessor :hour, :minute

  def initialize
    self.hour = 0
    self.minute = 0
  end

  def calculate_balance(time_1, time_2)
    calculate(-(time_1.hour.hours + time_1.min.minutes), (time_2.hour.hours + time_2.min.minutes))

    @cleared = time_1 == time_2
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

end
