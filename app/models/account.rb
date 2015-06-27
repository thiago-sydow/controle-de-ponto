class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :workload, type: Time, default: Time.zone.local(1999, 8, 1).change(hour: 8, minute: 0)
  field :active, type: Boolean, default: false

  validates_presence_of :name, :workload

  belongs_to :user

  has_many :day_records, dependent: :delete
  has_many :closures, dependent: :delete

  scope :active, -> { where(active: true) }
end
