require "spec_helper"

describe Rico do
  before :each do
    RiakHelpers.reset!
  end

  describe ".configure" do
    it "accepts a namespace" do
      Rico.configure do |r|
        r.namespace = "myapp"
      end

      Rico.namespace.should eql "myapp"
    end

    it "accepts a hash of options" do
      Rico.configure do |r|
        r.options = { http_port: 5151 }
      end

      Rico.options.should eql({ http_port: 5151 })
    end
  end

  describe ".bucket" do
    describe "namespacing" do
      it "supports an empty namespace" do
        Rico.namespace = nil
        Rico.bucket("users").name.should eql "users"
      end

      it "supports a single namespace" do
        Rico.namespace = "development"
        Rico.bucket("users").name.should eql "development:users"
      end

      it "supports multiple namespaces" do
        Rico.namespace = ["myapp", "development"]
        Rico.bucket("users").name.should eql "myapp:development:users"
      end
    end
  end
end
