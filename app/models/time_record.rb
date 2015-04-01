class TimeRecord
  include Mongoid::Document

  field :time, type: Time

  belongs_to :day_record

  default_scope -> { asc(:time) }

  def self.max_count
    collection.aggregate(
      { "$group" => {
          "_id": "$day_record_id",
          "count": { "$sum": 1 }
      }}
    ).map { |c| c['count'] }.max || 0
  end
end
