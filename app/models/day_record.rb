class DayRecord
  include Mongoid::Document
  extend Enumerize

  field :reference_date, type: Date, default: Date.current
  field :observations, type: String
  field :work_day
  field :missed_day

  enumerize :work_day, in: {yes: 1, no: 0}, default: :yes
  enumerize :missed_day, in: {yes: 1, no: 0}, default: :no

  belongs_to :user
  has_many :time_records, dependent: :delete

  default_scope -> { desc(:reference_date) }

end
