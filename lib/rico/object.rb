module Rico
  module Object
    extend Forwardable

    def_delegators :riak_object, :conflict?, :content_type, :content_type=, :data, :delete, :store, :raw_data

    # Initialize an object with a bucket and key
    #
    # bucket - the name of the bucket (not prefixed by a namespace)
    # key - the name of the key
    #
    # Returns nothing
    def initialize(bucket, key)
      @bucket, @key = bucket, key
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

    def riak_object
      @riak_object ||= Rico.bucket(@bucket).get_or_new @key
    end
  end
end
