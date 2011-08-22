#
# The cache cleaning rake tasks
#
namespace :app do

  def nuke(entries)
    entries.each do |entry|
      system "rm -rf #{Rails.root}/public/#{entry}"
    end
  end

  desc "Cleans all the application cache"
  task :clean do
    Rake::Task['app:clean:news'].invoke
    Rake::Task['app:clean:pages'].invoke
    Rake::Task['app:clean:packages'].invoke
  end

  namespace :clean do
    desc "Cleans the news feed cache"
    task :news do
      nuke ["news.*", "news/page/"]
      nuke ["news/#{ENV['NEWS_URI']}.html"] if ENV['NEWS_URI']
    end

    desc "Cleans the shows feed cache"
    task :shows do
      nuke ["shows.*", "shows/page/"]
      nuke ["shows/#{ENV['SHOW_URI']}.html"] if ENV['SHOW_URI']
    end

    desc "Cleans the static pages cache"
    task :pages do
      nuke ["index.html", "about.html", "terms.html"]
    end

    desc "Cleans the packages cache"
    task :packages do
      nuke [
        "index.html",
        "packages.html",
        "packages.json",
        "packages/page*",
        "packages/search*",
        "packages/recent*",
        "packages/updated*",
        "users/*/packages*"
      ]

      if ENV['PACKAGE']
        nuke ["packages/#{ENV['PACKAGE']}*"]
      end
    end
  end

end