class News < ActiveRecord::Base
  belongs_to :author, :foreign_key => :author_id, :class_name => "User"

  attr_accessible :title, :text

  validates_presence_of   :title, :text
  validates_uniqueness_of :title, :uri, :allow_blank => true

  before_validation :build_uri, :on => :create

  def self.find(id, *args)
    if args.empty? and id.is_a?(String) and id !=~ /^\d+$/
      find_by_uri(id) or raise(ActiveRecord::RecordNotFound)
    else
      super id, *args
    end
  end

  def to_param
    uri
  end

protected

  # making an uri out of the title
  def build_uri
    unless title.blank?
      self.uri = title.mb_chars.normalize(:d).split(//u).reject { |e| e.length > 1
      }.join.gsub("\n", " ").gsub(/[^a-z0-9\-_ \.]+/i, '').squeeze(' '
      ).gsub(/ |\.|_/, '-').gsub(/\-+/, '-').gsub(/(^\-)|(\-$)/, '').downcase
    end
  end
end
