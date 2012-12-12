require "spec_helper"

describe Rico::SortedMap do
  before :each do
    RiakHelpers.reset!
  end

  describe "#add" do
    it "sorts in instance" do
      a = Rico::SortedMap.new RiakHelpers.bucket, "sorted_map_add_1"
      a.add({"x" => 1, "4" => 2, "a" => 3})
      a.members.should eql({"4" => 2, "a" => 3, "x" => 1})
    end

    it "sort is retained on read" do
      a = Rico::SortedMap.new RiakHelpers.bucket, "sorted_map_add_2"
      a.add({"x" => 1, "4" => 2, "a" => 3})
      b = Rico::SortedMap.new RiakHelpers.bucket, "sorted_map_add_2"
      b.members.should eql({"4" => 2, "a" => 3, "x" => 1})
    end
  end
end
