require 'spec_helper'

describe Tag do
  describe "validation" do
    let(:tag) { Factory.build(:tag) }

    it "should pass with valid attributes" do
      tag.should be_valid
    end

    it "should fail without a name" do
      tag.name = ''
      tag.should have(1).error_on(:name)
    end

    it "should fail with a non-uniq name" do
      Factory.create(:tag, :name => "some name")
      tag.name = "some name"
      tag.should have(1).error_on(:name)
    end

    it "should fail with a malformed name" do
      tag.name = "some#ugly-shit"
      tag.should have(1).error_on(:name)
    end
  end
end
