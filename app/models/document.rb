class Document < ActiveRecord::Base
  belongs_to :version

  validates_presence_of   :path, :text
  validates_associated    :version
  validates_uniqueness_of :path, :scope => :version_id
  validates_length_of     :text, :maximum => 250.kilobytes, :allow_blank => true


  module Assoc
    def index
      where(:path => 'index').first
    end

    def urls
      all.map &:path
    end
  end
end
