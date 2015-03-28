class DayRecord
  include Mongoid::Document

  field :reference_date, type: Date
  field :observations, type: String
  field :work_day, type: Boolean

  belongs_to :user
  has_many :time_records
end
