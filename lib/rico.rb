require "riak"

require "rico/object"

require "rico/array"
require "rico/list"
require "rico/set"
require "rico/sorted_set"
require "rico/value"

require "rico/version"

module Rico

  def self.configure
    yield self if block_given?
  end

  def self.bucket(key)
    namespaced_key = [@namespace, key].flatten.select(&:present?).join(":")
    @bucket_cache ||= {}
    @bucket_cache[namespaced_key] ||= riak.bucket(namespaced_key)
  end

  def self.namespace
    @namespace
  end

  def self.namespace=(namespace)
    @namespace = namespace
  end

  def self.riak
    @riak ||= Riak::Client.new
  end

  def self.riak=(riak)
    @riak = riak
  end
end
