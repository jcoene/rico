require "spec_helper"

describe Rico::CappedSortedMap do
  before :each do
    RiakHelpers.reset!
  end

  let :test_map do
    values = 900.upto(999).map {|i| [i.to_s, i] }
    Hash[values.shuffle]
  end

  describe "#add" do
    it "sorts and caps in instance" do
      a = Rico::CappedSortedMap.new RiakHelpers.bucket, "capped_sorted_map_add_1", limit: 34
      a.add(test_map)
      a.members.length.should eql 34
      Array(a.members).first.should eql(["966", 966])
    end

    it "sort and cap is retained on read" do
      a = Rico::CappedSortedMap.new RiakHelpers.bucket, "capped_sorted_map_add_1", limit: 34
      a.add(test_map)
      a.members.length.should eql 34
      Array(a.members).first.should eql(["966", 966])
      b = Rico::CappedSortedMap.new RiakHelpers.bucket, "capped_sorted_map_add_1"
      b.members.length.should eql 34
      Array(b.members).first.should eql(["966", 966])
    end

    it "raises an error if a limit is not set" do
      a = Rico::CappedSortedMap.new RiakHelpers.bucket, "capped_sorted_map_add_1"
      lambda { a.add({"a" => 1}) }.should raise_error(ArgumentError)
    end
  end
end
