require "spec_helper"

describe Rico::SortedSet do
  before :each do
    RiakHelpers.reset!
  end

  describe "#add" do
    it "dedupes and sorts in instance" do
      a = Rico::SortedSet.new RiakHelpers.bucket, "sorted_set_add_1"
      a.add(3, 2, 2, 1, 1)
      a.members.should eql [1, 2, 3]
    end

    it "dedupes and sort is retained on read" do
      a = Rico::SortedSet.new RiakHelpers.bucket, "sorted_set_add_2"
      a.add(3, 3, 2, 2, 1)
      b = Rico::SortedSet.new RiakHelpers.bucket, "sorted_set_add_2"
      b.members.should eql [1, 2, 3]
    end
  end
end
