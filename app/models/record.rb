class Record
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Enum

  field :time, type: DateTime
  enum :record_type, [:normal, :extra_hour], default: :normal
  belongs_to :user


  default_scope -> { asc(:time) }

end