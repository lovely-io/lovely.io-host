atom_feed do |feed|
  feed.title "Lovely.IO News"
  feed.updated @news.first.updated_at if @news.size > 0

  @news.each do |news|
    feed.entry(news) do |entry|
      entry.title news.title
      entry.content md(news.text.split('<cut>').first), :type => :html
      entry.updated news.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")

      entry.author do |author|
        author.name news.author.name
      end
    end
  end
end