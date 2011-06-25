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

  describe "#readme markdown conversion" do
    before do
      @version = Version.new
    end

    it "should convert markdown into HTML on fly" do
      @version.readme = <<-EOS.gsub(/^\s*\|/, '')
        |# Header
        |
        |Some text
        |
        |    Some code
        |
        |More text
      EOS

      @version.readme.should == <<-EOS.gsub(/^\s*\|/, '')
        |<h1>Header</h1>
        |
        |<p>Some text</p>
        |
        |<pre><code>Some code
        |</code></pre>
        |
        |<p>More text</p>
      EOS
    end

    it "should escape any HTML content" do
      @version.readme = <<-EOS.gsub(/^\s*\|/, '')
        |<p>Some text</p>
        |<script>alert("Hello!");</script>
        |<style>h1 { font-size: 10em; }</style>
      EOS

      @version.readme.should == <<-EOS.gsub(/^\s*\|/, '')
        |<p>Some text
        |alert(&quot;Hello!&quot;);
        |h1 { font-size: 10em; }</p>
      EOS
    end
  end
end
