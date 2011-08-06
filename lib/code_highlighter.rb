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

    response.body = response.body.gsub /([ \t]*)<pre>:([a-z]+)(\s+.+?)<\/pre>/m do |match|
      %Q{<pre data-lang="#{$2}">#{ $3.gsub("\n#{$1}", "\n") }</pre>}
    end

    p response.body
  end
end