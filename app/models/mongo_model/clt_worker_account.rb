class MongoModel::CltWorkerAccount < MongoModel::Account

  field :lunch_time, type: Time

  ## CLT
  field :warn_straight_hours, type: Boolean, default: true
  field :warn_overtime, type: Boolean, default: true
  field :warn_rest_period, type: Boolean, default: true

  field :allowance_time, type: Time

end
