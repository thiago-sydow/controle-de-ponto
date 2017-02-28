# ModelCollection provides a collection with information about pagination. Ex:
#
# paged = ModelCollection.new(User.all)
# paged.collection (returns the ActiveRecord::Relation informed)
# paged.total_pages
# paged.has_next_page?
#
class ModelCollection
  attr_reader :collection, :has_next_page, :total_pages, :total_items_count

  def initialize(collection_relation)
    @collection = collection_relation
    @total_pages = collection_relation.total_pages
    @total_items_count = collection_relation.total_count
    @has_next_page = @total_pages.positive? && !(collection_relation.last_page? || collection_relation.empty?)
  end

  alias_method :has_next_page?, :has_next_page
end
