require "spec_helper"

describe Rico::Resolver do
  describe ".to_proc" do
    it "returns nil for data without type" do
      datas = [
        { "a" => "b" },
        { "c" => "d" },
        { "f" => "e" }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "resolver_proc_no_type", datas
      Rico::Resolver.to_proc.call(conflicted).should eql nil
    end

    it "returns nil for data with conflicted types" do
      datas = [
        { "_type" => "array", "_values" => [1,2,3,4,1] },
        { "_type" => "set", "_values" => [1,2,3,4] }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "resolver_proc_conflicted_types", datas
      Rico::Resolver.to_proc.call(conflicted).should eql nil
    end

    it "returns nil for data without a known rico class" do
      datas = [
        { "_type" => "unknown", "_values" => [1,2,3] },
        { "_type" => "unknown", "_values" => [1,2,3,4] }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "resolver_proc_unknown_type", datas
      Rico::Resolver.to_proc.call(conflicted).should eql nil
    end

    it "returns the result of the resolve function on known types" do
      datas = [
        { "_type" => "array", "_values" => [1,2,3] },
        { "_type" => "array", "_values" => [1,2,3,4] }
      ]
      conflicted = RiakHelpers.build_conflicted_robject "resolver_proc_no_resolve_function", datas

      Rico::Array.stub(:resolve).and_return(conflicted.siblings.last)
      Rico::Resolver.to_proc.call(conflicted).should eql conflicted.siblings.last
      Rico::Array.unstub(:resolve)
    end
  end
end
