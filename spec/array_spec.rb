require "spec_helper"

describe Rico::Array do
  before :each do
    RiakHelpers.reset!
  end

  describe "#add" do
    it "writes a single value to an array" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_single_value"
      a.add 5
      b = Rico::Array.new RiakHelpers.bucket, "array_add_single_value"
      b.members.should eql [5]
    end

    it "writes values to an array" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_writes_values"
      a.add [1, 2, 3]
      b = Rico::Array.new RiakHelpers.bucket, "array_add_writes_values"
      b.members.should eql [1, 2, 3]
    end

    it "allows duplicate values" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_allows_duplicates"
      a.add [1, 2, 3]
      a.add [2, 3, 4]
      b = Rico::Array.new RiakHelpers.bucket, "array_add_allows_duplicates"
      b.members.should eql [1, 2, 3, 2, 3, 4]
    end

    it "retains order of addition" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_retains_order"
      a.add [5, 3, 1, 6, 7]
      b = Rico::Array.new RiakHelpers.bucket, "array_add_retains_order"
      b.members.should eql [5, 3, 1, 6, 7]
    end

    it "works with strings" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_strings"
      a.add ["john", "joe", "jason"]
      a.add ["brian", "bob"]
      b = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_strings"
      b.members.should eql ["john", "joe", "jason", "brian", "bob"]
    end

    it "works with arrays" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_arrays"
      a.add [[1,2,3], [4,5,6], [7,8,9]]
      a.add [["a", "b", 37.2]]
      b = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_arrays"
      b.members.should eql [[1,2,3], [4,5,6], [7,8,9], ["a", "b", 37.2]]
    end

    it "works with hashmaps" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_hashmaps"
      a.add [{a: 1, b: 2}, {charlie: 6}]
      a.add [{"usd" => 37.2, "eur" => 31.6}]
      b = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_hashmaps"
      b.members.should eql [{"a" => 1, "b" => 2}, {"charlie" => 6}, {"usd" => 37.2, "eur" => 31.6}]
    end

    it "works with mixed types" do
      a = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_mixed_types"
      a.add [{"usd" => 123.41, "cad" => 61.89}]
      a.add ["Bears", "Beets", "Battlestar Galactica"]
      a.add 3.14159
      a.add 71
      b = Rico::Array.new RiakHelpers.bucket, "array_add_works_with_mixed_types"
      b.members.should eql [{"usd" => 123.41, "cad" => 61.89}, "Bears", "Beets", "Battlestar Galactica", 3.14159, 71]
    end
  end

  describe "#remove" do
    it "removes existing values" do
      a = Rico::Array.new RiakHelpers.bucket, "array_remove_removes"
      a.add [{"usd" => 123.41, "cad" => 61.89}, "Bears", "Beets", :slumdog, "Battlestar Galactica", 3.14159, 71]
      b = Rico::Array.new RiakHelpers.bucket, "array_remove_removes"
      b.remove [3.14159, "Beets"]
      b.remove ["slumdog"]
      c = Rico::Array.new RiakHelpers.bucket, "array_remove_removes"
      c.members.should eql [{"usd" => 123.41, "cad" => 61.89}, "Bears", "Battlestar Galactica", 71]
    end

    it "does not throw on removal on non-key" do
      lambda do
        Rico::Array.new(RiakHelpers.bucket, "array_remove_nonkey").remove("bill")
      end.should_not raise_error
    end

    it "does not throw on removal on non-value" do
      lambda do
        a = Rico::Array.new RiakHelpers.bucket, "array_remove_nonvalue"
        a.add [37, 68, 54]
        a.remove "josh"
      end.should_not raise_error
    end
  end

  describe "#members" do
    it "asserts value type as array" do
      a = Rico::Map.new RiakHelpers.bucket, "array_members_assert_type"
      a.add({"a" => 1})
      b = Rico::Array.new RiakHelpers.bucket, "array_members_assert_type"
      lambda { b.members }.should raise_error(TypeError)
    end

    it "returns a list of members" do
      a = Rico::Array.new RiakHelpers.bucket, "array_members_lists"
      a.add [{"usd" => 123.41, "cad" => 61.89}, "Bears", "Beets", "Battlestar Galactica", 3.14159, 71]
      b = Rico::Array.new RiakHelpers.bucket, "array_members_lists"
      b.members.should eql [{"usd" => 123.41, "cad" => 61.89}, "Bears", "Beets", "Battlestar Galactica", 3.14159, 71]
    end
  end

  describe "#member?" do
    it "returns a true if a member" do
      a = Rico::Array.new RiakHelpers.bucket, "array_members_lists"
      a.add [{"usd" => 123.41, "cad" => 61.89}, "Bears", "Beets", "Battlestar Galactica", 3.14159, 71]
      b = Rico::Array.new RiakHelpers.bucket, "array_members_lists"
      b.member?({"usd" => 123.41, "cad" => 61.89}).should eql true
    end

    it "returns a true if not a member" do
      a = Rico::Array.new RiakHelpers.bucket, "array_members_lists"
      a.add [{"usd" => 123.41, "cad" => 61.89}, "Bears", "Beets", "Battlestar Galactica", 3.14159, 71]
      b = Rico::Array.new RiakHelpers.bucket, "array_members_lists"
      b.member?({"usd" => 123.42, "cad" => 61.89}).should eql false
    end
  end

  describe "#length" do
    it "returns zero for an empty list" do
      a = Rico::Array.new RiakHelpers.bucket, "array_length_empty"
      a.length.should eql 0
    end

    it "returns the number of entries" do
      a = Rico::Array.new RiakHelpers.bucket, "array_length_6"
      a.add [1, 2, 3, 4, 5, 6]
      a.length.should eql 6
    end

    it "is aliased to #count" do
      a = Rico::Array.new RiakHelpers.bucket, "array_length_alias"
      a.add [1, 2, 3, 4, 5, 6]
      a.count.should eql 6
    end
  end

  describe ".resolve" do
    it "properly resolves missing values" do
      datas = [
        { "_type" => "array", "_values" => [1,2,3] },
        { "_type" => "array", "_values" => [1,2,3,4] }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "array_resolve_simple", datas
      result = Rico::Array.resolve(conflicted)
      result.data["_values"].should eql [1,2,3,4]
    end

    it "properly deletes deleted values after resolve" do
      datas = [
        { "_type" => "array", "_values" => [1,2,3,4] },
        { "_type" => "array", "_values" => [1,2,3], "_deletes" => [4] }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "array_resolve_delete", datas
      result = Rico::Array.resolve(conflicted)
      result.data["_values"].should eql [1,2,3]
      result.data["_deletes"].should eql [4]
    end
  end

  it "is enumerable" do
    a = Rico::Array.new RiakHelpers.bucket, "array_enumerable"
    a.add [3, 1, 4, 1, 5, 9]
    a.to_a.should eql [3, 1, 4, 1, 5, 9]
    a.each { }.length.should eql 6
    a.map {|x| x + 1 }.should eql [4, 2, 5, 2, 6, 10]
    a[4].should eql 5
  end
end
