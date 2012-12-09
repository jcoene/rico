require "spec_helper"

describe Rico::Set do
  before :each do
    RiakHelpers.reset!
  end

  describe "#add" do
    it "dedupes and retains order in instance" do
      a = Rico::Set.new RiakHelpers.bucket, "set_add_1"
      a.add(3, 4, 6, 8, 1, 2, 3, 4, 7)
      a.members.should eql [3, 4, 6, 8, 1, 2, 7]
    end

    it "dedupes and sort is retained on read" do
      a = Rico::Set.new RiakHelpers.bucket, "set_add_2"
      a.add(3, 4, 6, 8, 1, 2, 3, 4, 7)
      b = Rico::Set.new RiakHelpers.bucket, "set_add_2"
      b.members.should eql [3, 4, 6, 8, 1, 2, 7]
    end
  end
end
