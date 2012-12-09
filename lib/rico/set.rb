module Rico
  class Set < Array
    protected

    def compute_add(items)
      super(items).uniq
    end

    def compute_remove(items)
      super(items).uniq
    end
  end
end
