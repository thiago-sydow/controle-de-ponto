class TimeRecord < ActiveRecord::Base
  belongs_to :day_record, inverse_of: :time_records

  validates_presence_of :time

  default_scope -> { order(time: :asc) }

  after_initialize :set_default_values

  def self.max_time_count(days_scope)
    TimeRecord
    .unscope(:order)
    .where(day_record_id: days_scope.select(:id))
    .group(:day_record_id)
    .pluck("count(id) as time_count")
    .max || 0
  end

  private

  def set_default_values
    self.time ||= Time.current
  end

end
