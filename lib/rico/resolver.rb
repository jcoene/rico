module Rico
  class Resolver
    def self.to_proc
      @to_proc ||= lambda do |robject|
        klasses = robject.siblings.map{|s| s.data && s.data["_type"] }.compact.uniq
        return nil unless klasses.length == 1

        klass_name = Rico::TYPES.invert[klasses.first]
        return nil unless klass_name

        klass = Rico.const_get(klass_name)
        return nil unless klass.respond_to?(:resolve)

        klass.resolve(robject.siblings)
      end
    end
  end
end
