require "spec_helper"

describe Rico::Value do
  before :each do
    RiakHelpers.reset!
  end

  describe "#exists?" do
    it "returns true if it exists" do
      a = Rico::Value.new RiakHelpers.bucket, "value_exists_true"
      a.set "bob"
      b = Rico::Value.new RiakHelpers.bucket, "value_exists_true"
      b.exists?.should eql true
    end

    it "returns false if it does not exists" do
      a = Rico::Value.new RiakHelpers.bucket, "value_exists_false"
      a.exists?.should eql false
    end
  end

  describe "#get" do
    it "returns the value" do
      a = Rico::Value.new RiakHelpers.bucket, "value_get_return_value"
      a.set([1, 2, 3, 4, 5, "bob", "joe"])
      b = Rico::Value.new RiakHelpers.bucket, "value_get_return_value"
      b.get.should eql [1, 2, 3, 4, 5, "bob", "joe"]
    end

    it "returns nil if the value does not exist" do
      a = Rico::Value.new RiakHelpers.bucket, "value_get_nil"
      a.get.should eql nil
    end
  end

  describe "#set" do
    it "writes the value" do
      a = Rico::Value.new RiakHelpers.bucket, "value_set"
      a.set "john"
      b = Rico::Value.new RiakHelpers.bucket, "value_set"
      b.get.should eql "john"
    end
  end

  describe "#setnx" do
    it "writes the value, returns true if new" do
      a = Rico::Value.new RiakHelpers.bucket, "setnx_new"
      a.setnx("value").should eql true
      b = Rico::Value.new RiakHelpers.bucket, "setnx_new"
      b.get.should eql "value"
    end

    it "does nothing, returns false if the value exists" do
      a = Rico::Value.new RiakHelpers.bucket, "setnx_exists"
      a.set "value"
      b = Rico::Value.new RiakHelpers.bucket, "setnx_exists"
      b.setnx("other").should eql false
      b.get.should eql "value"
      c = Rico::Value.new RiakHelpers.bucket, "setnx_exists"
      c.get.should eql "value"
    end
  end

  describe "#delete" do
    it "deletes an existing object" do
      a = Rico::Value.new RiakHelpers.bucket, "delete_existing"
      a.set "john"
      a.delete
      b = Rico::Value.new RiakHelpers.bucket, "delete_existing"
      b.exists?.should eql false
      b.get.should eql nil
    end
  end
end
