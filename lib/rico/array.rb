module Rico
  class Array
    include Rico::Object
    include Enumerable
    extend Forwardable

    def_delegators :members, :each, :[], :length, :count

    public

    # Adds the requested items to the array and stores the object
    #
    # items - items to be added to the array
    #
    # Returns the result of the store operation
    def add(*items)
      mutate compute_add(items)
    end

    # Removes the requested items from the array and stores the object
    #
    # items - items to be removed from the array
    #
    # Returns the result of the store operation
    def remove(*items)
      mutate compute_remove(items)
    end

    # Obtains the items in the array
    #
    # Returns the data in the object as an array
    def members
      Array(data)
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

    def compute_add(items)
      members + items
    end

    def compute_remove(items)
      members - items
    end
  end
end
