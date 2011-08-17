class Tag < ActiveRecord::Base
  has_and_belongs_to_many :packages, :order => 'packages.name', :uniq => true

  validates_presence_of   :name
  validates_uniqueness_of :name, :allow_blank => true
  validates_format_of     :name, :allow_blank => true, :with => /^[a-z0-9 ]+$/i, :message => 'is malformed'

  class << self
    def find(*args)
      if args.size == 1 && args[0].is_a?(String) && !(args[0] =~ /^\d+$/)
        find_by_name(args[0]) or raise ActiveRecord::RecordNotFound
      else
        super *args
      end
    end
  end

  # package association extension
  module Assoc
    def build_from_string(string)
      package   = proxy_owner
      allow_stl = package.owner && package.owner.admin?

      tags = string.split(',').map do |tag|
        tag.blank? ? nil : tag.strip
      end.compact

      package.tags = tags.map do |tag|
        if tag.downcase != 'stl' or allow_stl
          Tag.find_or_create_by_name(tag)
        end
      end.compact
    end
  end
end
