module Rico
  class Array < Collection

    public

    # Obtains the items in the array
    #
    # Returns the data in the object as an array
    def members
      Array((data || {})["_values"])
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
  end
end
