module Rico
  class Collection
    include Rico::Object
    include Enumerable
    extend Forwardable

    def_delegators :members, :each, :[], :length, :count

    # Adds the requested items to the array and stores the object
    #
    # items - items to be added to the array
    #
    # Returns the result of the store operation
    def add(*items)
      mutate build_map_add(items)
    end

    # Removes the requested items from the array and stores the object
    #
    # items - items to be removed from the array
    #
    # Returns the result of the store operation
    def remove(*items)
      mutate build_map_remove(items)
    end

    # Tests whether or not an item exists in the array
    #
    # item - item to test against
    #
    # Returns true or false
    def member?(item)
      members.include? item
    end

    protected

    def build_map_add(items)
      { "_type" => type_key, "_values" => compute_add(items) }
    end

    def build_map_remove(items)
      { "_type" => type_key, "_values" => compute_remove(items), "_deletes" => items }
    end

    def compute_add(items)
      members + items
    end

    def compute_remove(items)
      members - items
    end
  end
end
