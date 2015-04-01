class DayRecord
  include Mongoid::Document
  extend Enumerize

  ZERO_HOUR = Time.current.change(hour: 0, minute: 0)

  field :reference_date, type: Date, default: Date.current
  field :observations, type: String
  field :work_day
  field :missed_day

  enumerize :work_day, in: {yes: 1, no: 0}, default: :yes
  enumerize :missed_day, in: {yes: 1, no: 0}, default: :no

  belongs_to :user
  has_many :time_records, dependent: :delete

  accepts_nested_attributes_for :time_records, reject_if: :all_blank, allow_destroy: true

  validates_uniqueness_of :reference_date, scope: :user_id
  default_scope -> { desc(:reference_date) }

  def balance
    balance = ZERO_HOUR

    return balance if time_records.empty?

    reference_time = time_records.first
    time_records.each_with_index do |time_record, index|
      diff = Time.diff(reference_time.time, time_record.time)

      if index.odd?
        balance = (balance + diff[:hour].hours) + diff[:minute].minutes
      end

      reference_time = time_record
    end

    if reference_date.today? && time_records.size.even?
      balance
    else
      byebug
      now_diff = Time.diff(reference_time.time, Time.current)
      (balance + now_diff[:hour].hours) + now_diff[:minute].minutes
    end

  end

end
