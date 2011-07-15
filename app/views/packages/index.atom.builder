atom_feed do |feed|
  feed.title "Lovely.IO Updates"
  feed.updated @packages.first.updated_at if @packages.size > 0

  @packages.each do |package|
    feed.entry(package) do |entry|
      versions = package.versions.all
      version  = versions.first

      entry.title "#{package.name} - #{version.number}"
      entry.content %Q{
        #{link_to(package.owner.name, user_url(package.owner))} just
        #{package.updated_at > (package.created_at + 10) ? "updated" : "created"} the
        #{link_to(package.name, package_url(package))} package with version
        #{version.number}
      }.html_safe, :type => :html

      entry.updated package.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")

      entry.author do |author|
        author.name package.owner.name
      end
    end
  end
end