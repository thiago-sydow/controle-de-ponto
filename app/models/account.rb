class Account < ActiveRecord::Base

  validates_presence_of :name, :workload

  belongs_to :user

  has_many :day_records, dependent: :destroy
  has_many :closures, dependent: :delete_all

end
