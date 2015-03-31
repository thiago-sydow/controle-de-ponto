class TimeRecord
  include Mongoid::Document

  field :time, type: Time

  belongs_to :day_record

  default_scope -> { asc(:time) }
end
