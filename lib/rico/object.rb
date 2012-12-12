module Rico
  module Object
    extend Forwardable

    def_delegators :riak_object, :conflict?, :content_type, :content_type=, :delete, :store, :raw_data

    attr_accessor :bucket, :key

    # Initialize an object with a bucket and key
    #
    # bucket - the name of the bucket (not prefixed by a namespace)
    # key - the name of the key
    #
    # Returns nothing
    def initialize(bucket, key, options={})
      @bucket, @key = bucket, key
      options.each {|k,v| send("#{k}=", v)}
    end

    # Retrieves data from Riak
    #
    # Raises an error on type mismatch
    def data
      result = riak_object.data || {}

      if result["_type"] && (result["_type"] != type_key)
        raise TypeError, "#{@bucket}:#{@key} expected type to be #{type_key}, got #{result["_type"]}"
      end

      result
    end

    # Sets a new value on the object and stores it
    #
    # value - new value to set
    #
    # Returns the result of the store operation
    def mutate(value)
      riak_object.data = value
      store
    end

    # Determine whether an object exists or not
    #
    # Returns true or false
    def exists?
      Rico.bucket(@bucket).exists? @key
    end

    protected

    def type_key
      name = self.class.name.split("::").last
      Rico::TYPES[name]
    end

    def assert_type(klass, &block)
      value = block.call

      unless value.class == klass
        raise TypeError, "#{@bucket}:#{@key} expected value to be #{klass.name}, got #{value.class}"
      end

      value
    end

    def riak_object
      @riak_object ||= Rico.bucket(@bucket).get_or_new @key
    end
  end
end
