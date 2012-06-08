#
# Some patches for the Redcarpet, to make the result html better
#
class LovelyRenderer < Redcarpet::Render::HTML

  CODE_LANG_RE = /\A:([a-z]+)/

  def block_code(code, language)
    code   ||= ''
    language = code.scan(CODE_LANG_RE)[0][0] rescue nil unless language
    code     = code.gsub(CODE_LANG_RE, '').strip
    code     = code.gsub("\n", '&#x000A;')
    code     = code.gsub("<", '&lt;')
    code     = code.gsub(">", '&gt;')

    "<pre data-lang='#{language || "unspecified"}'>#{code}</pre>"
  end

  def codespan(code)
    "<tt>#{code}</tt>"
  end
end