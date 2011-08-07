atom_feed do |feed|
  feed.title "Lovely.IO Updates"
  feed.updated @packages.first.updated_at if @packages.size > 0

  @packages.each do |package|
    versions = package.versions.all
    version  = versions.last

    feed.entry(version, :url => package_url(package)) do |entry|
      entry.title "#{package.name} - #{version.number}"
      entry.content %Q{
        #{link_to(package.owner.name, user_url(package.owner))} just
        #{versions.size > 1 ? "updated" : "created"} the
        #{link_to(package.name, package_url(package))} package with version
        #{link_to(version.number, package_url(package, :version => version.number))}
      }.html_safe, :type => :html

      entry.updated package.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")

      entry.author do |author|
        author.name package.owner.name
      end
    end
  end
end