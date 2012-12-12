require "spec_helper"

describe Rico::Map do
  before :each do
    RiakHelpers.reset!
  end

  describe "#add" do
    it "writes a single hash to the map" do
      a = Rico::Map.new RiakHelpers.bucket, "map_add_single_hash"
      a.add({"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5})
      b = Rico::Map.new RiakHelpers.bucket, "map_add_single_hash"
      b.members.should eql({"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5})
    end

    it "supports multiple multiple writes to the map" do
      a = Rico::Map.new RiakHelpers.bucket, "map_add_multiple_writes"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      a.add({"d" => 4, "e" => 5})
      b = Rico::Map.new RiakHelpers.bucket, "map_add_multiple_writes"
      b.members.should eql({"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5})
    end

    it "merges in the right order with implicit deduping" do
      a = Rico::Map.new RiakHelpers.bucket, "map_add_order_dedupe"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      a.add({"b" => "B", "c" => "C"})
      b = Rico::Map.new RiakHelpers.bucket, "map_add_order_dedupe"
      b.members.should eql({"a" => 1, "b" => "B", "c" => "C"})
    end
  end

  describe "#remove" do
    it "removes a single key by string" do
      a = Rico::Map.new RiakHelpers.bucket, "map_remove_single_key_string"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      b = Rico::Map.new RiakHelpers.bucket, "map_remove_single_key_string"
      b.remove("a")
      c = Rico::Map.new RiakHelpers.bucket, "map_remove_single_key_string"
      c.members.should eql({"b" => 2, "c" => 3})
    end

    it "removes multiple keys by string" do
      a = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_string"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      b = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_string"
      b.remove(["a", "c"])
      c = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_string"
      c.members.should eql({"b" => 2})
    end

    it "removes multiple keys by symbol" do
      a = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_symbol"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      b = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_symbol"
      b.remove([:a, :c])
      c = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_symbol"
      c.members.should eql({"b" => 2})
    end

    it "removes multiple keys by integer" do
      a = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_integer"
      a.add({1 => 1, 2 => 2, 3 => 3})
      b = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_integer"
      b.remove([1, 3])
      c = Rico::Map.new RiakHelpers.bucket, "map_remove_multiple_keys_integer"
      c.members.should eql({"2" => 2})
    end

    it "removes multiple keys by map tuples" do
      a = Rico::Map.new RiakHelpers.bucket, "map_remove_single_key_tuple"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      b = Rico::Map.new RiakHelpers.bucket, "map_remove_single_key_tuple"
      b.remove({"a" => 1, "b" => 2})
      c = Rico::Map.new RiakHelpers.bucket, "map_remove_single_key_tuple"
      c.members.should eql({"c" => 3})
    end

    it "merges in the right order with implicit deduping" do
      a = Rico::Map.new RiakHelpers.bucket, "map_remove_order_dedupe"
      a.add({"a" => 1, "b" => 2, "c" => 3, "d" => 4})
      a.remove({"b" => 2, "c" => 3, "c" => 3, "c" => 3})
      b = Rico::Map.new RiakHelpers.bucket, "map_remove_order_dedupe"
      b.members.should eql({"a" => 1, "d" => 4})
    end
  end

  describe "#members" do
    it "asserts value type as hash" do
      a = Rico::Array.new RiakHelpers.bucket, "map_members_assert_type"
      a.add [1,2,3]
      b = Rico::Map.new RiakHelpers.bucket, "map_members_assert_type"
      lambda { b.members }.should raise_error(TypeError)
    end
  end

  describe "#length" do
    it "returns zero for an empty list" do
      a = Rico::Map.new RiakHelpers.bucket, "map_length_empty"
      a.length.should eql 0
    end

    it "returns the number of entries" do
      a = Rico::Map.new RiakHelpers.bucket, "map_length_6"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      a.length.should eql 3
    end

    it "is aliased to #count" do
      a = Rico::Map.new RiakHelpers.bucket, "map_length_alias"
      a.add({"a" => 1, "b" => 2, "c" => 3})
      a.count.should eql 3
    end
  end

  describe ".resolve" do
    it "properly resolves missing values" do
      datas = [
        { "_type" => "map", "_values" => {"a" => 11, "b" => 12} },
        { "_type" => "map", "_values" => {"a" => 11, "b" => 12, "c" => 13} }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "map_resolve_simple", datas
      result = Rico::Map.resolve(conflicted)
      result.data["_values"].should eql({"a" => 11, "b" => 12, "c" => 13})
    end

    it "properly deletes deleted values after resolve" do
      datas = [
        { "_type" => "map", "_values" => {"a" => 11, "b" => 12, "c" => 13} },
        { "_type" => "map", "_values" => {"a" => 11, "b" => 12}, "_deletes" => ["c"] }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "map_resolve_delete", datas
      result = Rico::Map.resolve(conflicted)
      result.data["_values"].should eql({"a" => 11, "b" => 12})
      result.data["_deletes"].should eql ["c"]
    end
  end

  it "is enumerable" do
    a = Rico::Map.new RiakHelpers.bucket, "map_enumerable"
    a.add({"a" => 1, "b" => 2})
    a.to_a.should eql [["a", 1], ["b", 2]]
    a.each { }.length.should eql 2
    a.map {|k,v| v + 1 }.should eql [2, 3]
    a["b"].should eql 2
  end
end
