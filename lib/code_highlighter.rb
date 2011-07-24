#
# The code samples post-processing module
#
module CodeHighlighter
  def self.included(base)
    base.instance_eval do
      after_filter :highlight_code_blocks
    end
  end

protected

  def highlight_code_blocks
    return if response.content_type != 'text/html'

    response.body = response.body.gsub /([ \t]+)<pre>(.+?)<\/pre>/im do
      code = $2.gsub "\n#{$1}", "\n"

      "<pre>#{code.strip}</pre>".gsub /<pre>:([a-z]+)\s+/ do
        "<pre data-lang=\"#{$1}\">"
      end
    end
  end
end