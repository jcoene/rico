require "spec_helper"

describe Rico::Value do
  before :each do
    RiakHelpers.reset!
  end

  def gunzip(string)
    io = StringIO.new(string)
    gz = Zlib::GzipReader.new(io)
    object = gz.read
    gz.close
    object
  end

  describe "gzip serialization" do
    it "sets the content type of gzip objects" do
      a = Rico::Value.new RiakHelpers.bucket, "value_gzip_content_type"
      a.content_type = "application/x-gzip"
      a.set "JOHN DOE"
      a.content_type.should eql "application/x-gzip"
    end

    it "properly serializes of gzip objects" do
      a = Rico::Value.new RiakHelpers.bucket, "value_gzip_content_type"
      a.content_type = "application/x-gzip"
      a.set "JOHN DOE"
      gunzip(a.raw_data).should eql "\"JOHN DOE\""
      a.content_type.should eql "application/x-gzip"
    end

    it "retrieves the content type of persisted gzip objects" do
      a = Rico::Value.new RiakHelpers.bucket, "value_gzip_content_type_2"
      a.content_type = "application/x-gzip"
      a.set "JOHN DOE"

      b = Rico::Value.new RiakHelpers.bucket, "value_gzip_content_type_2"
      b.content_type.should eql "application/x-gzip"
      b.get.should eql "JOHN DOE"
    end
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

  describe ".resolve" do
    it "just returns the first sibling" do
      datas = ["Tom", "Jerry"]
      conflicted = RiakHelpers.build_conflicted_robject "value_resolve_simple", datas
      result = Rico::Value.resolve(conflicted)
      result.data.should eql "Tom"
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

end
