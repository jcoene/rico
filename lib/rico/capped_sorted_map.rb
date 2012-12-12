module Rico
  class CappedSortedMap < Map
    attr_accessor :limit

    protected

    def compute_add(items)
      unless @limit
        raise ArgumentError, "please specify a limit in item construction"
      end

      Hash[super(items).sort.pop(@limit)]
    end

    def compute_remove(items)
      Hash[super(items).sort]
    end
  end
end
