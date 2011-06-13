class User < ActiveRecord::Base
  attr_accessible :email, :name, :home_url

  validates_presence_of :provider, :uid, :name
  validate :provider_and_uid_uniqueness, :on => :create

  # find or create a user by omni-auth data-hash
  def self.find_or_create_by_auth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid']) ||
    create! do |user|
      user.uid        = auth['uid']
      user.provider   = auth['provider']
      user.name       = auth['user_info']['name']
      user.location   = auth['user_info']['location']
      user.avatar_url = auth['user_info']['image']
      user.home_url   = case auth['provider']
        when 'github'   then "http://github.com/#{auth['user_info']['nickname']}"
        when 'twitter'  then "http://twitter.com/#{auth['user_info']['nickname']}"
        when 'facebook' then "http://www.facebook.com/profile.php?id=#{auth['uid']}"
        else nil
      end
    end
  end

  def admin?
    'admin' == role
  end

private

  def provider_and_uid_uniqueness
    if self.class.find_by_provider_and_uid(provider, uid)
      self.errors.add(:uid, "is already taken for this provider")
    end
  end
end
