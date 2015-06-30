class SelfEmployedAccount < Account
  field :hourly_rate, type: BigDecimal, default: 0.0

  validates_format_of :hourly_rate, with: /\A\d+(?:\.\d{0,2})?\z/
end