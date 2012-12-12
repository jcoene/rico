module Rico
  class Map < Collection

    public

    # Obtains the items in the array
    #
    # Returns the data in the object as an array
    def members
      ((data || {})["_values"] || {})
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

    def build_map_add(items)
      { "_type" => type_key, "_values" => compute_add(items) }
    end

    def build_map_remove(items)
      keys = extract_keys(items)
      { "_type" => type_key, "_values" => compute_remove(items), "_deletes" => keys }
    end

    def compute_add(items)
      members.merge(items)
    end

    def compute_remove(items)
      keys = extract_keys(items)
      members.delete_if {|k,v| keys.include? k.to_s }
    end

    def extract_keys(items)
      Array(items).map {|i| i.respond_to?(:keys) ? i.keys : i }.flatten.map(&:to_s)
    end
  end
end
