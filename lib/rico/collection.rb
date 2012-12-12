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
    def add(items)
      mutate build_map_add(items)
    end

    # Removes the requested items from the array and stores the object
    #
    # items - items to be removed from the array
    #
    # Returns the result of the store operation
    def remove(items)
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
  end
end
