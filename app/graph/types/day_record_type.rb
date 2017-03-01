module Types
  DayRecordType = GraphQL::ObjectType.define do
    name 'DayRecord'
    description 'Record which holds information about the day and it\'s respective times'

    field :referenceDate, !ISODateType, 'Day of this record', property: :reference_date
    field :observations, types.String, 'Observations included'
    field :workDay, !types.Boolean, 'If the day is considered as a work day', property: :work_day?
    field :missedDay, !types.Boolean, 'If the user did not work', property: :missed_day?
    field :medicalCertificate, !types.Boolean, 'If the user have a medical certificate for the day', property: :medical_certificate?
    field :totalWorked, !types.Int, 'Total time worked (in seconds)' do
      resolve -> (obj, _args, ctx) {
        Loaders::AssociationLoader.for(DayRecord, :time_records, page: 1, page_size: 100).load(obj).then do
          obj.total_worked
        end
      }
    end

    field :timeRecords, 'Time records for the day' do
      type Helpers::CollectionForClass.for(TimeRecord)

      argument :pageSize, types.Int, default_value: 100
      argument :page, types.Int, default_value: 1

      resolve -> (obj, args, ctx) {
        Loaders::AssociationLoader.for(DayRecord, :time_records, page: args[:page], page_size: args[:pageSize]).load(obj)
      }
    end
  end
end
