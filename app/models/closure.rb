class Closure
  include Mongoid::Document

  field :start_date, type: Date
  field :end_date, type: Date

  belongs_to :user

  validates_presence_of :start_date, :end_date

  default_scope -> { desc(:start_date) }

  def balance
    user.day_records.where(reference_date: start_date..end_date).
    inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
  end
end