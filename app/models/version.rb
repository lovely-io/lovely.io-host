require 'redcarpet'

class Version < ActiveRecord::Base
  belongs_to :package

  validates_presence_of   :number, :build, :readme
  validates_format_of     :number, :with => /^\d+\.\d+\.\d+(-[a-z0-9\.]+)?$/i, :allow_blank => true
  validates_uniqueness_of :number, :scope => :package_id, :allow_blank => true

  def readme=(markdown)
    super Redcarpet.new(markdown, :filter_html, :safelink).to_html
  end
end
