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
      if exists?
        false
      else
        set value
        true
      end
    end

    # Resolve conflict between one or more RObject siblings
    #
    # This currently just returns the first sibling
    #
    # robjects - array of RObjects to resolve
    #
    # Returns a single RObject result or nil
    def self.resolve(robject)
      obj = Riak::RObject.new(robject.bucket, robject.key)
      obj.data = robject.siblings.first.data
      obj
    end
  end
end
