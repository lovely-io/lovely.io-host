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

    response.body = response.body.gsub /([ \t]*)<pre([^>]*)>(:([a-z]+))?(.+?)<\/pre>/m do
      %Q{<pre#{$2}#{" data-lang=\"#{$4}\"" unless $4.blank?}>#{ $5.gsub("\n#{$1}", "\n").strip }</pre>}
    end
  end
end