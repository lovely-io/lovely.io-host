require 'spec_helper'

describe Document do
  describe "validation" do
    before do
      Document.destroy_all
      @document = Document.new Factory.attributes_for(:document, :version_id => 1)
    end

    it "should pass with valid attributes" do
      @document.should be_valid
    end

    it "should fail without the version-id" do
      @document.version_id = nil
      @document.should have(1).error_on(:version_id)
    end

    it "should fail without a path" do
      @document.path = ''
      @document.should have(1).error_on(:path)
    end

    it "should fail with a non-uniq path" do
      Factory.create(:document, :version_id => @document.version_id, :path => @document.path)
      @document.should have(1).error_on(:path)
    end

    it "should pass if the path is used in a different version" do
      Factory.create(:document, :version_id => @document.version_id + 1, :path => @document.path)
      @document.should be_valid
    end

    it "should fail without some text" do
      @document.text = ''
      @document.should have(1).error_on(:text)
    end

    it "should fail with too large text" do
      @document.text = 'a' * 256.kilobytes
      @document.should have(1).error_on(:text)
    end
  end
end
