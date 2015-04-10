class TimeBalance

  BASE_TIME = Time.zone.local(1999, 8, 1)

  def initialize(workload, worked)
    @workload_time  = BASE_TIME.change(hour: workload.hour, min: workload.min)
    @worked_time = BASE_TIME.change(hour: worked.hour, min: worked.min)

    calculate_balance
  end

  def positive?
    @workload_time < @worked_time
  end

  def cleared?
    @workload_time == @worked_time
  end

  def to_s
    "%02d:%02d" % [@hour, @minute]
  end

  private

  def get_ordered
    major = @workload_time
    minor = @worked_time

    if positive?
      major = @worked_time
      minor = @workload_time
    end

    [major, minor]
  end

  def calculate_balance
    major, minor = get_ordered

    diff = Time.diff(major, minor)
    @hour = diff[:hour]
    @minute = diff[:minute]
  end

end
