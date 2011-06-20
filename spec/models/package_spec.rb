require 'spec_helper'

describe Package do
  describe "validation" do
    before do
      @package = Package.new

      Factory.attributes_for(:package).each do |key, value|
        @package.send("#{key}=", value)
      end

      @package.owner = Factory.create(:user)
    end

    it "should pass with valid attributes" do
      @package.should be_valid
    end

    it "should fail without an owner reference" do
      @package.owner_id = nil
      @package.should have(1).error_on(:owner_id)
    end

    it "should fail without a name" do
      @package.name = ''
      @package.should have(1).error_on(:name)
    end

    it "should fail with a malformed name" do
      @package.name = '--boo---'
      @package.should have(1).error_on(:name)
    end

    it "should fail with a non-uniq name" do
      @package.name = Factory.create(:package).name
      @package.should have(1).error_on(:name)
    end

    it "should fail without a description" do
      @package.description = ''
      @package.should have(1).error_on(:description)
    end

    it "should fail without a version number" do
      @package.version = ''
      @package.should have(1).error_on(:version)
    end

    it "should fail with a malformed number" do
      @package.version = 'some crap'
      @package.should have(1).error_on(:version)
    end
  end

  describe "#version assignment" do
    before do
      @package = Package.new
      @package.version = '1.0.0'
    end

    it "should create a Version reference" do
      @package.should have(1).versions
    end

    it "should bypass the version number" do
      @package.versions[0].number.should == '1.0.0'
    end

    it "should return the version number back" do
      @package.version.should == '1.0.0'
    end
  end
end
