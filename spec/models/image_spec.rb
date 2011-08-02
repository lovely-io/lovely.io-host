require 'spec_helper'

describe Image do
  describe "validation" do
    let(:image) { Factory.build(:image) }

    it "should pass with valid attributes" do
      image.should be_valid
    end

    it "should fail without a path" do
      image.path = ''
      image.should have(1).error_on(:path)
    end

    it "should fail with a malformed path" do
      image.path = 'som[shit]'
      image.should have(1).error_on(:path)
    end

    it "should fail with an unsupported image type" do
      image.path = "something.rar"
      image.should have(1).error_on(:base)
    end

    it "should fail with a non-uniq path" do
      Factory.create(:image, :path => image.path, :version_id => image.version_id)
      image.should have(1).error_on(:path)
    end

    it "should allow same name for a different version" do
      Factory.create(:image, :path => image.path, :version_id => image.version_id + 1)
      image.should be_valid
    end

    it "should fail without data" do
      image.data = ''
      image.should have(1).error_on(:data)
    end

    it "should fail with too large data" do
      image.data = 'a' * 256.kilobytes
      image.should have(1).error_on(:data)
    end
  end

  describe "#raw_data" do
    before do
      require "base64"

      @image = Factory.build(:image)
      @image.data = Base64.encode64("original data")
    end

    it "should return the original data" do
      @image.raw_data.should == "original data"
    end
  end

  describe "#content_type" do
    let(:image) { Factory.build(:image) }

    it "should return correct type for .png" do
      image.path = "test.png"
      image.content_type.should == "image/png"
    end

    it "should return correct type for .gif" do
      image.path = "test.gif"
      image.content_type.should == "image/gif"
    end

    it "should return correct type for .jpeg" do
      image.path = "test.jpeg"
      image.content_type.should == "image/jpg"
    end

    it "should return correct type for .jpg" do
      image.path = "test.jpg"
      image.content_type.should == "image/jpg"
    end

    it "should return correct type for .svg" do
      image.path = "test.svg"
      image.content_type.should == "image/svg+xml"
    end

    it "should return correct type for .swf" do
      image.path = "test.swf"
      image.content_type.should == "application/x-shockwave-flash"
    end

    it "should return 'text/plain' for unknown types" do
      image.path = "some.shit"
      image.content_type.should == "text/plain"
    end
  end
end
