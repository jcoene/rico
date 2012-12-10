$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require "rubygems"
require "rico"

module RiakHelpers
  def self.bucket
    "rico_test"
  end

  def self.reset!
    Rico.namespace = "test"

    Riak.disable_list_keys_warnings = true
    b = Rico.bucket(bucket)
    b.keys.each do |k|
      b.delete k
    end

    a = Rico::Array.new bucket, "visual_array"
    a.add 1,2,3,4,5,6
    a.remove 6
  end

  def self.build_conflicted_robject(key, values)
    bucket = Rico.bucket RiakHelpers.bucket
    o = Riak::RObject.new bucket, key
    siblings = values.map do |v|
      x = Riak::RObject.new bucket, key
      x.data = v
      x
    end

    o = Riak::RObject.new bucket, key
    o.siblings = siblings
    o
  end

  def self.build_conflicted_rico_object(klass, key, values=["v1", "v2", "v3"])
    o = build_conflicted_robject key, values
    v = klass.new RiakHelpers.bucket, key
    v.instance_variable_set("@riak_object", o)
    v
  end
end
