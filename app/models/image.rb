require "base64"

class Image < ActiveRecord::Base
  belongs_to :version

  validates_presence_of   :path, :data
  validates_uniqueness_of :path, :scope => :version_id
  validates_format_of     :path, :with  => /^[a-z0-9\/\-\._\/]+$/, :allow_blank => true
  validates_length_of     :data, :maximum => 250.kilobytes,        :allow_blank => true

  validate :mime_type_check

  def raw_data
    Base64.decode64(data)
  end

protected

  def mime_type_check
    if path && !(path =~ /\.(png|gif|jpg|jpeg|swf|svg)$/)
      errors.add(:base, "Unsupported image type")
    end
  end
end
