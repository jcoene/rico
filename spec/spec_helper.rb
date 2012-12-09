$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require "rubygems"
require "rico"

module RiakHelpers
  def self.bucket
    "rico_test"
  end

  def self.reset!
    Rico.namespace = "test"
    Rico.riak = Riak::Client.new(http_port: 8091)

    Riak.disable_list_keys_warnings = true
    b = Rico.bucket(bucket)
    b.keys.each do |k|
      b.delete k
    end
  end
end
