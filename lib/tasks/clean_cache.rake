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

    desc "Cleans the static pages cache"
    task :pages do
      nuke ["index.html", "about.html"]
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
        "packages/updated*"
      ]

      if ENV['PACKAGE']
        nuke ["packages/#{ENV['PACKAGE']}*"]

        if ENV['VERSION']
          assets_dir = ASSETS_DIR.gsub("#{Rails.root}/public/")
          nuke [
            "#{assets_dir}/#{ENV['PACKAGE']}-#{ENV['VERSION']}.js",
            "#{assets_dir}/#{ENV['PACKAGE']}/#{ENV['VERSION']}/"
          ]
        end
      end
    end
  end

end