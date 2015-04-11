class TimeBalance

  BASE_TIME = Time.zone.local(1999, 8, 1)

  attr_accessor :hour, :minute

  def initialize
    @hour = 0
    @minute = 0
  end

  def calculate_balance(time_1, time_2)
    time_1  = BASE_TIME.change(hour: time_1.hour, min: time_1.min)
    time_2 = BASE_TIME.change(hour: time_2.hour, min: time_2.min)

    @hour, @minute = calculate(time_1, time_2)

    @positive = time_2 > time_1
    @cleared = time_1 == time_2
  end

  def positive?
    @positive
  end

  def cleared?
    @cleared
  end

  def sum(balance)
    @hour += balance.hour
    @minute += balance.minute
  end

  def to_s
    "%02d:%02d" % [@hour, @minute]
  end

  private

  def get_ordered(time_1, time_2)
    major, minor = [time_1, time_2].sort.reverse

    [major, minor]
  end

  def calculate(time_1, time_2)
    major, minor = get_ordered(time_1, time_2)

    total = major.to_i - minor.to_i
    mm, ss = total.divmod(60)

    mm.divmod(60)
  end

end
