module Types
  module Helpers
    # A Helper to dynamically create a Collection type for a class, with pagination related fields
    # eg. hasNextPage, totalPages...
    #
    # CollectionForClass.for(DayRecord) - Returns a DayRecordCollection
    # collection field includes an Array of objects of the given class
    class CollectionForClass
      def self.for(model_class)
        # We can't define a Type more than once, so we memoize it to load directly if already defined
        @class_map ||= {}
        @class_map[model_class] ||= build_paginated_object_type(model_class)
      end

      def self.build_paginated_object_type(model_class)
        GraphQL::ObjectType.define do
          name "#{model_class.name}Collection"

          field :collection, types["Types::#{model_class.name}Type".constantize]
          field :hasNextPage, types.Boolean, property: :has_next_page?
          field :totalPages, types.Int, property: :total_pages
          field :totalItemsCount, types.Int, property: :total_items_count
        end
      end
    end
  end
end
