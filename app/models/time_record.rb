class TimeRecord < ActiveRecord::Base
  belongs_to :day_record, inverse_of: :time_records

  validates_presence_of :time

  default_scope -> { order(time: :asc) }

  after_initialize :set_default_values

  private

  def set_default_values
    self.time ||= Time.current
  end

end
