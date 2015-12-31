class MongoModel::Account
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "accounts"

  field :name, type: String
  field :workload, type: Time, default: Time.zone.local(1999, 8, 1).change(hour: 8, minute: 0)
  field :active, type: Boolean, default: false

  validates_presence_of :name, :workload

  belongs_to :user, class_name: MongoModel::User.to_s

  has_many :day_records, class_name: MongoModel::DayRecord.to_s, dependent: :delete
  has_many :closures, class_name: MongoModel::Closure.to_s, dependent: :delete

  scope :active, -> { where(active: true) }

end
