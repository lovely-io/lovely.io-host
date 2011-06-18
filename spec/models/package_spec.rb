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

    it "should be valid with valid attributes" do
      @package.should be_valid
    end

    it "should be invalid without an owner reference" do
      @package.owner_id = nil
      @package.should have(1).error_on(:owner_id)
    end

    it "should be invalid without a name" do
      @package.name = ''
      @package.should have(1).error_on(:name)
    end

    it "should be invalid with a malformed name" do
      @package.name = '--boo---'
      @package.should have(1).error_on(:name)
    end

    it "should be invalid with a non-uniq name" do
      @package.name = Factory.create(:package).name
      @package.should have(1).error_on(:name)
    end

    it "should be invalid without a description" do
      @package.description = ''
      @package.should have(1).error_on(:description)
    end
  end
end
