module DocsHelper
  #
  # Builds a list of docname/urls list of documents in the package
  #
  def api_docs_index(package)
    package.documents.api.sort_by(&:path).map do |doc|
      doc_id  = doc.path.sub(/^docs\//, '').sub(/\.md$/, '')
      doc_url = package_docs_path(@package, :version => params[:version], :doc_id => doc_id)

      [doc_id, doc_url]
    end
  end

  def md(string='')
    html  = MARKDOWN.render(string)
    index = 0
    regex = /\{([a-z\.\|]+)\}/i

    while index = html.index(regex, index)
      match = html.slice(index, html.size)[regex]
      index = index + match.size

      if (html.index('</pre>', index) || html.size) > (html.index(/<pre[^>]*>/, index) || html.size-1)
        html = html.slice(0, index - match.size) +
          api_docs_link(match.slice(1,match.size-2)) +
          html.slice(index, html.size)
      end
    end

    html.html_safe
  end

  # allows to run greps on a text without huring h1,h2,h3,h4,a,pre,tt and so on tags content
  RENDERER = LovelyRenderer.new(
    :filter_html =>         true)

  MARKDOWN = Redcarpet::Markdown.new(RENDERER,
    :no_intra_emphasis =>   true,
    :parse_tables =>        true,
    :fenced_code_blocks =>  true,
    :autolink =>            true,
    :space_after_headers => true,
    :superscript =>         true)


  API_DOC_RE = /(<pre[^>]+data-lang=)('|")([^'"]+)\-aside\2([^>]*)(>.*?<\/pre>)/

  #
  # API docs formatted markdown
  #
  def api_doc_md(doc)
    html = md(@document.text)

    if html =~ API_DOC_RE
      table = []

      while pre_block = html[API_DOC_RE]
        table << [
          api_doc_parse_docs(html.slice(0, html.index(API_DOC_RE))),
          api_doc_parse_code(pre_block)
        ]

        html = html.slice(html.index(API_DOC_RE) + pre_block.size, html.size)
      end

      html = %Q{
        <table class="api-doc">#{
          table.map do |entry|
            "<tr><td>"+entry[0]+"</td><td>"+entry[1]+"</td></tr>"
          end.join("\n")
        }</table>
      }.html_safe
    end

    return html
  end

private

  #
  # Generates the api-doc link by a standard reference
  #
  def api_docs_link(reference)
    reference.split('|').map do |token|
      if token.include?('.')
        package = Package.where(:name => token.slice(0, token.index('.'))).first
        doc_pre = token.slice(token.index('.')+1, token.size)
      else
        package = @package
        doc_pre = token
      end

      doc = package && package.documents.api.detect do |doc|
        doc.path.starts_with?("docs/#{doc_pre.underscore}.")
      end

      if doc
        doc_id  = doc.path.sub(/^docs\//, '').sub(/\.md$/, '')
        doc_url = package_docs_path(package, :version => package == @package ? params[:version] : nil, :doc_id => doc_id)
      else
        doc_url = '#'
      end

      link_to token, doc_url, :class => 'api-ref'
    end.join('|')
  end

  #
  # Prepares the code block to be inserted into the api-doc table
  #
  def api_doc_parse_code(code_block)
    code_block.sub /(<pre[^>]+data-lang=)('|")([^'"]+)-aside\2/, '\1\2\3\2'
  end

  #
  # Additional parsing for the documentation block
  #
  def api_doc_parse_docs(html)
    html.gsub /<p>(\s*@[a-z]+.+?)<\/p>/m do |match|
      text = $1.dup.gsub /(@[a-z]+\s*)(\{[^}]+\})?(\s*[^@]+)/m do |m|
        "<div><strong>#{$1}</strong><em>#{$2}</em>#{$3}</div>"
      end


      "<section class='api'>#{text}</section>"
    end
  end

end