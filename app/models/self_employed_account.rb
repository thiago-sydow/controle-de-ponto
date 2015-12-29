class SelfEmployedAccount < Account
  store_accessor :preferences, :hourly_rate

  validates_presence_of :hourly_rate
  validates_format_of :hourly_rate, with: /\A\d+(?:\.\d{0,2})?\z/

end
