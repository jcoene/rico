module Rico
  class Value
    include Rico::Object

    # Gets the value of the object
    #
    # Returns the deserialized value
    def get
      (data || {})["_value"]
    end

    # Sets and stores the new value for the object
    #
    # value - the new value to store
    #
    # Returns the result of the store operation
    def set(value)
      mutate build_map(value)
    end

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

    protected

    def build_map(value)
      { "_type" => type_key, "_value" => value }
    end
  end
end
