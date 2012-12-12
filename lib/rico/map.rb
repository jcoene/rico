module Rico
  class Map < Collection

    public

    # Obtains the items in the array
    #
    # Returns the data in the object as an array
    def members
      assert_type(::Hash) do
        data["_values"] || {}
      end
    end

    # Resolve conflict between one or more RObject siblings
    #
    # robjects - array of RObjects to merge
    #
    # Returns a single RObject result or nil
    def self.resolve(robject)
      siblings = robject.siblings
      values = siblings.map {|r| (r.data["_values"] || {}) }
      deletions = siblings.map {|r| Array(r.data["_deletes"]) }.flatten
      result = values.inject({}) {|res, h| res.merge(h) }.reject {|k,v| deletions.include? k }

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
      keys = extract_keys(items)
      { "_type" => type_key, "_values" => compute_remove(items), "_deletes" => keys }
    end

    # Add items to our member hash
    #
    # items - Items to add
    #
    # Returns a Hash of the resulting merge
    def compute_add(items)
      members.merge(items)
    end

    # Remove items from our member hash
    #
    # items - Items to remove. Can be a hash, array of keys or single key
    #
    # Returns a Hash of the new object
    def compute_remove(items)
      keys = extract_keys(items)
      members.delete_if {|k,v| keys.include? k.to_s }
    end

    def extract_keys(items)
      Array(items).map {|i| i.respond_to?(:keys) ? i.keys : i }.flatten.map(&:to_s)
    end
  end
end
