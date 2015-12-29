class CltWorkerAccount < Account

  store_accessor :preferences, :lunch_time, :warn_straight_hours,
                 :warn_overtime, :warn_rest_period, :allowance_time

  after_initialize :set_default_values


  def self.default_build_hash
    {
      type: 'CltWorkerAccount',
      name: 'Emprego CLT',
      warn_overtime: true,
      warn_rest_period: true,
      warn_straight_hours: true
    }
  end

  private

  def set_default_values
    self.lunch_time ||= 0
    self.allowance_time ||= 0
  end

end
