class MongoModel::TimeRecord
  include Mongoid::Document

  field :time, type: Time, default: -> { Time.current }

  embedded_in :day_record, class_name: MongoModel::DayRecord.to_s

  validates_presence_of :time

  default_scope -> { asc(:time) }

end
