module Rico
  class SortedMap < Map
    protected

    def compute_add(items)
      Hash[super(items).sort]
    end

    def compute_remove(items)
      Hash[super(items).sort]
    end
  end
end
