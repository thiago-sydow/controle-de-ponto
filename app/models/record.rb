class Record
  include Mongoid::Document

  field :time, type: DateTime
  belongs_to :user
  validates_presence_of :time, :user_id

  default_scope -> { asc(:time) }

end
