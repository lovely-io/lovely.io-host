module DocsHelper
  API_DOC_RE = /(<pre[^>]+data-lang=)('|")([^'"]+)\-aside\2([^>]*)(>.+?<\/pre>)/

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
  # Prepares the code block to be inserted into the api-doc table
  #
  def api_doc_parse_code(code_block)
    code_block.sub /(<pre[^>]+data-lang=)('|")([^'"]+)-aside\2/, '\1\2\3\2'
  end

  #
  # Additional parsing for the documentation block
  #
  def api_doc_parse_docs(html)
    html.gsub /<p>(\s*@(param|return|throws).+?)<\/p>/m do |match|
      text = $1.dup
      "<p>#{text}</p>"
    end
  end

end