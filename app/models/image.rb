require "base64"
require "digest"

class Image < ActiveRecord::Base
  belongs_to :version

  validates_presence_of   :path, :data
  validates_uniqueness_of :path, :scope => :version_id
  validates_format_of     :path, :with  => /^[a-z0-9\/\-\._\/]+$/, :allow_blank => true
  validates_length_of     :data, :maximum => 250.kilobytes,        :allow_blank => true

  validate    :mime_type_check

  def raw_data
    Base64.decode64(data)
  end

  def raw_data=(src)
    self.data = Base64.encode64(src)

  end

  def data=(data)
    self.sha  = Digest::SHA1.hexdigest(data)
    super data
  end

  def content_type
    case (path || '').split('.').last
      when 'png'         then "image/png"
      when 'gif'         then "image/gif"
      when 'jpg', 'jpeg' then "image/jpg"
      when 'svg'         then "image/svg+xml"
      when 'swf'         then "application/x-shockwave-flash"
      when 'eot'         then "application/vnd.ms-fontobject"
      when 'ttf'         then "application/x-font-ttf"
      when 'woff'        then "application/x-font-woff"
      else                    "text/plain"
    end
  end

protected

  def mime_type_check
    if path && !(path =~ /\.(png|gif|jpg|jpeg|swf|svg|eot|ttf|woff)$/)
      errors.add(:base, "Unsupported image type")
    end
  end
end
