class Closure
  include Mongoid::Document

  field :start_date, type: Date
  field :end_date, type: Date

  validates_presence_of :start_date, :end_date

  default_scope -> { desc(:start_date) }

end
