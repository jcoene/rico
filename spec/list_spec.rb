require "spec_helper"

describe Rico::List do
  before :each do
    RiakHelpers.reset!
  end

  describe "#add" do
    it "adds values and sorts them in instance" do
      a = Rico::List.new RiakHelpers.bucket, "list_add_1"
      a.add [3, 2, 1]
      a.members.should eql [1, 2, 3]
    end

    it "adds values and sorts them on read" do
      a = Rico::List.new RiakHelpers.bucket, "list_add_2"
      a.add [3, 2, 1]
      b = Rico::List.new RiakHelpers.bucket, "list_add_2"
      b.members.should eql [1, 2, 3]
    end

    it "allows duplicates of the same value" do
      a = Rico::List.new RiakHelpers.bucket, "list_add_duplicate"
      a.add [3, 6, 4, 1, 7, 9, 1, 1, 3, 3]
      b = Rico::List.new RiakHelpers.bucket, "list_add_duplicate"
      b.members.should eql [1, 1, 1, 3, 3, 3, 4, 6, 7, 9]
    end
  end

  describe "#remove" do
    it "removes all occurence of the item" do
      a = Rico::List.new RiakHelpers.bucket, "list_remove_all_duplicates"
      a.add [1, 1, 1, 2, 2, 2]
      b = Rico::List.new RiakHelpers.bucket, "list_remove_all_duplicates"
      b.remove [1, 2]
      c = Rico::List.new RiakHelpers.bucket, "list_remove_all_duplicates"
      c.members.should eql []
    end
  end
end
