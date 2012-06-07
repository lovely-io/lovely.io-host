require 'spec_helper'

describe Tag do
  describe "validation" do
    let(:tag) { FactoryGirl.build(:tag) }

    it "should pass with valid attributes" do
      tag.should be_valid
    end

    it "should fail without a name" do
      tag.name = ''
      tag.should have(1).error_on(:name)
    end

    it "should fail with a non-uniq name" do
      FactoryGirl.create(:tag, :name => "some name")
      tag.name = "some name"
      tag.should have(1).error_on(:name)
    end

    it "should fail with a malformed name" do
      tag.name = "some#ugly-shit"
      tag.should have(1).error_on(:name)
    end
  end

  describe "package association" do
    let(:package) { FactoryGirl.build(:package) }

    it "should create all tags on assignment" do
      package.tags = " boobies, cookies, football "
      package.tags.map(&:name).should == ['boobies', 'cookies', 'football']
    end

    it "should keep the tags case" do
      package.tags = "STUFF, Thing"
      package.tags.map(&:name).should == ['STUFF', 'Thing']
    end

    it "should reuse existing tags" do
      t1 = FactoryGirl.create(:tag, :name => "one")
      t2 = FactoryGirl.create(:tag, :name => "two")

      package.tags = "one,two"
      package.tags.should == [t1, t2]
    end

    it "should filter out the 'stl' tags unless the package owner is an admin" do
      package.tags = 'stl, one'
      package.tags.map(&:name).should == ['one']
    end

    it "should allow 'stl' tags for admin's packages" do
      package.owner = FactoryGirl.create(:user, :role => 'admin')
      package.tags  = 'stl, one'
      package.tags.map(&:name).should == ['stl', 'one']
    end
  end
end
