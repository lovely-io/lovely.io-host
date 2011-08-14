require 'zlib'

module PackagesHelper
  def cdn_package_url(package, version=nil)
    super package, version, :host => "cdn.#{request.host_with_port}"
  end

  def gzipped_size(string)
    io   = StringIO.new
    gzip = Zlib::GzipWriter.new(io)
    gzip << string
    gzip.close

    number_to_human_size(io.string.size)
  end

  def parse_changelog(text)
    index    = -1
    title_re = /(\d{4}\-\d{2}-\d{2})\s*(.+?)\n/
    output   = ''

    while index = text.index(title_re, index + 1)
      finish = text.index(title_re, index+1) || text.size

      entry = text.slice(index, finish - index)

      if title = entry.scan(title_re)[0]
        date = Date.parse(title[0])
        user = User.find_by_name(title[1])

        date = date ? date.to_s(:long) : title[0]
        user = user ? link_to(user.name, user, :class => :user) : title[1]



        records = entry.gsub(title_re, '').split(/\s*\*\s*/)
        records = records.slice(1, records.size).map do |entry|
          content_tag :li, entry.strip
        end


        output +=
          content_tag(:h2, (date + " - "+ user).html_safe) +
          content_tag(:ul, records.join("\n").html_safe)
      end
    end

    output.html_safe
  end
end