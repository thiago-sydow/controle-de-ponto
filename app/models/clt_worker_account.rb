class CltWorkerAccount < Account

  ## CLT
  field :warn_straight_hours, type: Boolean, default: true
  field :warn_overtime, type: Boolean, default: true
  field :warn_rest_period, type: Boolean, default: true

end