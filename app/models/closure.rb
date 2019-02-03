class Closure < ActiveRecord::Base
  belongs_to :account, touch: true

  validates_presence_of :start_date, :end_date

  validates_uniqueness_of :start_date, :end_date, scope: :account_id

  default_scope -> { order(end_date: :desc) }

  def balance
    Rails.cache.fetch("#{cache_key}/balance") do
      account
      .day_records.where(reference_date: start_date..end_date)
      .inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
    end
  end
end
