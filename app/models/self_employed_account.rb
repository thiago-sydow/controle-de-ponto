class SelfEmployedAccount < Account

  typed_store :preferences, coder: ActiveRecord::TypedStore::IdentityCoder do |s|
    s.float :hourly_rate, null: false
  end

  validates_presence_of :hourly_rate
  validates_format_of :hourly_rate, with: /\A\d+(?:\.\d{0,2})?\z/
end
