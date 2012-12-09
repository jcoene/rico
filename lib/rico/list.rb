module Rico
  class List < Array
    protected

    def compute_add(items)
      super(items).sort
    end

    def compute_remove(items)
      super(items).sort
    end
  end
end
