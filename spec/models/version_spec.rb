require 'spec_helper'

describe Version do
  describe "validation" do
    before do
      @package = Factory.create(:package)

      @version = Version.new(Factory.attributes_for(:version, :package => @package))
    end

    it "should pass with valid attributes" do
      @version.should be_valid
    end

    it "should fail without a number" do
      @version.number = ''
      @version.should have(1).error_on(:number)
    end

    it "should fail with a malformed number" do
      @version.number = 'alfa1'
      @version.should have(1).error_on(:number)
    end

    it "should fails with a non-uniq number" do
      Factory.create(:version, :package_id => @package, :number => @version.number)
      @version.should have(1).error_on(:number)
    end

    it "should allow '-smth' name suffixes" do
      @version.number += '-RC2'
      @version.should be_valid
    end

    it "should fail without a build" do
      @version.build = ''
      @version.should have(1).error_on(:build)
    end

    it "should fail without a readme doc" do
      @version.readme = ''
      @version.should have(1).error_on(:readme)
    end
  end
end
