require 'spec_helper'

describe Version do
  describe "validation" do
    before do
      @version = Version.new(Factory.attributes_for(:version, :package_id => 1))
    end

    it "should pass with valid attributes" do
      @version.should be_valid
    end

    it "should fail without a package reference" do
      @version.package_id = nil
      @version.should have(1).error_on(:package_id)
    end

    it "should fail without a number" do
      @version.number = ''
      @version.should have(1).error_on(:number)
    end

    it "should fail with a malformed number" do
      @version.number = 'alfa1'
      @version.should have(1).error_on(:number)
    end

    it "should fail with a non-uniq number" do
      Factory.create(:version, @version.attributes)
      @version.should have(1).error_on(:number)
    end

    it "should pass if the same version number is used in other package" do
      Factory.create(:version, @version.attributes.merge(:package_id => @version.package_id + 1))
      @version.should be_valid
    end

    it "should allow '-smth' name suffixes" do
      @version.number += '-RC2'
      @version.should be_valid
    end

    it "should fail without a build" do
      @version.build = ''
      @version.should have(1).error_on(:build)
    end

    it "should fail if the build is too huge" do
      @version.build = 'a' * 256.kilobytes
      @version.should have(1).error_on(:build)
    end
  end

  describe 'documents association' do
    describe '.index method' do
      before do
        @version  = Factory.create(:version, :package_id => 1)
        @document = Factory.create(:document, :version => @version, :path => 'index', :text => 'boo hoo')
      end

      it "should get found by the 'index' method" do
        Version.find(@version).documents.index.should == @document
      end
    end
  end
end
