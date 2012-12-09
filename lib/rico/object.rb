module Rico
  module Object
    extend Forwardable

    def_delegators :riak_object, :store, :delete

    # Initialize an object with a bucket and key
    #
    # bucket - the name of the bucket (not prefixed by a namespace)
    # key - the name of the key
    #
    # Returns nothing
    def initialize(bucket, key)
      @bucket, @key = bucket, key
    end

    def data
      @data ||= riak_object.data
    end

    # Sets a new value on the object and stores it
    #
    # value - new value to set
    #
    # Returns the result of the store operation
    def mutate(value)
      @data = value
      riak_object.data = value
      riak_object.store
    end

    # Determine whether an object exists or not
    #
    # Returns true or false
    def exists?
      Rico.bucket(@bucket).exists? @key
    end

    protected

    def riak_object
      @riak_object ||= Rico.bucket(@bucket).get_or_new @key
    end
  end
end
