class CltWorkerAccount < Account

  typed_store :preferences, coder: JSON do |s|
    s.boolean :warn_straight_hours, null: false
    s.boolean :warn_overtime, null: false
    s.boolean :warn_rest_period, null: false
    s.integer :lunch_time, null: false, default: 0
    s.integer :allowance_time, null: false, default: 0
  end

  def self.default_build_hash
    {
      type: 'CltWorkerAccount',
      name: 'Emprego CLT',
      warn_overtime: true,
      warn_rest_period: true,
      warn_straight_hours: true
    }
  end
end
