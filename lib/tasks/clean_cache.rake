#
# The cache cleaning rake tasks
#
namespace :app do

  def nuke(entries)
    entries.each do |entry|
      system "rm -rf #{Rails.root}/public/#{entry}"
    end
  end

  namespace :clean do
    desc "Cleans the news feed cache"
    task :news do
      nuke ["news.*", "news/page/*"]
      nuke ["news/#{ENV['NEWS_URI']}.html"] if ENV['NEWS_URI']
    end
  end

end