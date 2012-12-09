module Rico
  class Value
    include Rico::Object

    # Gets the value of the object
    #
    # Returns the deserialized value
    alias_method :get, :data

    # Sets and stores the new value for the object
    #
    # value - the new value to store
    #
    # Returns the result of the store operation
    alias_method :set, :mutate

    # Sets the value if it does not exist
    #
    # value - the value to store
    #
    # Returns true if stored, false if not
    def setnx(value)
      if redis_object.exists?
        false
      else
        set value
        true
      end
    end
  end
end
