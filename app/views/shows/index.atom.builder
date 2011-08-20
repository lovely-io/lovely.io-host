atom_feed do |feed|
  feed.title "Lovely.IO Episodes"
  feed.updated @shows.first.updated_at if @shows.size > 0

  @shows.each do |show|
    feed.entry(show) do |entry|
      entry.title   show.title
      entry.content %Q{
        #{md(show.text.split('<cut>').first)}
        <p>
          <a href="#{show.movie_url}">Download This Episode</a>
        </p>
      }, :type => :html
      entry.updated show.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")

      entry.author do |author|
        author.name show.author.name
      end
    end
  end
end