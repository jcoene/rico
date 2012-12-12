require "riak"

require "rico/object"
require "rico/collection"

require "rico/array"
require "rico/list"
require "rico/set"
require "rico/sorted_set"
require "rico/value"

require "rico/resolver"

require "rico/version"

module Rico

  TYPES = {
    "Array" => "array",
    "List" => "list",
    "Set" => "set",
    "SortedSet" => "sset",
    "Value" => "value"
  }

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

  def self.options
    @options || {}
  end

  def self.options=(options)
    @options = options
  end

  def self.riak
    Thread.current[:riak] ||= Riak::Client.new(options)
  end
end

module Riak
  module Serializers
    module ApplicationXGZIP
      extend self

      def dump(object)
        json = ApplicationJSON.dump(object)
        io = StringIO.new
        gz = Zlib::GzipWriter.new(io)
        gz.write(json)
        gz.close

        io.string
      end

      def load(string)
        io = StringIO.new(string)
        gz = Zlib::GzipReader.new(io)
        json = gz.read
        gz.close

        ApplicationJSON.load(json)
      end
    end

    Serializers['application/x-gzip'] = ApplicationXGZIP
  end
end

Riak::RObject.on_conflict(&Rico::Resolver.to_proc)
