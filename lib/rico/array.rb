module Rico
  class Array < Collection

    public

    # Obtains the items in the array
    #
    # Returns the data in the object as an array
    def members
      assert_type(::Array) do
        data["_values"] || []
      end
    end

    # Resolve conflict between one or more RObject siblings
    #
    # robjects - array of RObjects to merge
    #
    # Returns a single RObject result or nil
    def self.resolve(robject)
      siblings = robject.siblings
      values = siblings.map {|r| Array(r.data["_values"]) }
      deletions = siblings.map {|r| Array(r.data["_deletes"]) }.flatten

      result = []
      values.each do |v|
        result += (v - result)
      end

      result -= deletions

      obj = robject.dup
      obj.siblings = [obj.siblings.first]
      obj.data = { "_values" => result, "_deletes" => deletions }
      obj
    end

    protected

    # Constructs a document map for the given operation
    #
    # items - Items to add to members
    #
    # Returns a Hash representing the document map
    def build_map_add(items)
      { "_type" => type_key, "_values" => compute_add(items) }
    end

    # Constructs a document map for the given operation
    #
    # items - Items to remove to members
    #
    # Returns a Hash representing the document map
    def build_map_remove(items)
      { "_type" => type_key, "_values" => compute_remove(items), "_deletes" => items }
    end

    # Add items to our member array
    #
    # items - Items to add
    #
    # Returns an Array of the resulting addition
    def compute_add(items)
      members + Array(items)
    end

    # Remove items from our member array
    #
    # items - Items to remove. Can be an array of values or a single object
    #
    # Returns an Array of the new object
    def compute_remove(items)
      members - Array(items)
    end
  end
end
