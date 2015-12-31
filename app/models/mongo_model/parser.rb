class MongoModel::Parser
  def self.parsed_user_attributes(attributes)
    model = User.new
    attributes.reject{ |k,v| !model.attributes.keys.member?(k.to_s) }
  end

  def self.parsed_account_attributes(attributes)
    if attributes['_type'] == 'CltWorkerAccount'
      {
        "type"=>"CltWorkerAccount",
        "name"=> attributes['name'],
        "workload"=> parse_time_to_seconds(attributes['workload'].in_time_zone),
        "preferences"=>
          {
            "lunch_time"=> attributes['lunch_time'].present? ? parse_time_to_seconds(attributes['lunch_time'].in_time_zone) : 0,
            "allowance_time"=> attributes['allowance_time'].present? ? parse_time_to_seconds(attributes['allowance_time'].in_time_zone) : 0,
            "warn_straight_hours"=> attributes["warn_straight_hours"].nil? ? true : attributes["warn_straight_hours"],
            "warn_overtime"=> attributes["warn_overtime"].nil? ? true : attributes["warn_overtime"],
            "warn_rest_period"=> attributes["warn_rest_period"].nil? ? true : attributes["warn_rest_period"]
          }
      }
    elsif attributes['_type'] == 'StudentAccount'
      {
        "type"=>"StudentAccount",
        "name"=> attributes['name'],
        "workload"=> parse_time_to_seconds(attributes['workload'].in_time_zone)
      }
    elsif attributes['_type'] == 'SelfEmployedAccount'
      {
        "type"=>"SelfEmployedAccount",
        "name"=> attributes['name'],
        "workload"=> parse_time_to_seconds(attributes['workload'].in_time_zone),
        "preferences"=>
          {
            "hourly_rate"=> attributes['hourly_rate'].present? ? attributes['hourly_rate'] : 0.0
          }
      }
    else
      raise 'Something wrong here'
    end
  end

  def self.parsed_day_record_attributes(attributes)
    {
      'reference_date' => attributes['reference_date'].to_date,
      'observations' => attributes['observations'].to_s,
      'work_day' => attributes['work_day'].present? ? attributes['work_day'] : 1,
      'missed_day' => attributes['missed_day'].present? ? attributes['missed_day'] : 0,
      'medical_certificate' => attributes['medical_certificate'].present? ? attributes['medical_certificate'] : 0
    }
  end

  def self.parsed_time_record_attributes(attributes)
    { 'time' => attributes['time'].in_time_zone }
  end

  def self.parsed_closure_attributes(attributes)
    {
      'start_date' => attributes['start_date'].to_date,
      'end_date' => attributes['end_date'].to_date
    }
  end

  def self.parse_time_to_seconds(time)
    (time.hour.hours + time.min.minutes)
  end

end
