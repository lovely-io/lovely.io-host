require 'zlib'

module PackagesHelper
  def cdn_package_url(package, version=nil)
    super package, version, :host => "cdn.#{request.host_with_port.gsub('www.', '')}"
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

        output +=
          content_tag(:h2, (date + " - "+ user).html_safe) +
          md(entry.gsub(title_re, ''))
      end
    end

    output.html_safe
  end

  def tags_list(tags, options={})
    max  = 0
    tags = tags.map do |tag|
      packages_count = tag.packages.count
      max = packages_count if max < packages_count
      [tag.name, packages_count]
    end

    # weightening the list
    tags.each do |tag|
      tag[1] = (tag[1] / max.to_f * 10).to_i
    end

    options[:class] ||= ''
    options[:class] << ' tags'

    content_tag :ul, tags.map{ |tag|
      content_tag :li, content_tag(:a, tag[0], {
        :href => tagged_packages_path(tag[0]), :'data-weight' => tag[1]
      }), :class => params[:tag] == tag[0] ? 'current' : nil
    }.join("\n").html_safe, options
  end
end