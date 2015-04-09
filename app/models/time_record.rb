class TimeRecord
  include Mongoid::Document

  field :time, type: Time, default: Time.current

  embedded_in :day_record

  validates_presence_of :time

  default_scope -> { asc(:time) }

end
