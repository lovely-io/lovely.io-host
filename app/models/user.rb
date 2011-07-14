require 'bcrypt'

class User < ActiveRecord::Base
  has_many :packages, :order => :name, :foreign_key => :owner_id

  attr_accessible :email, :name, :home_url

  validates_presence_of :provider, :uid, :name
  validates_format_of :email, :with => /^[\w\d\.\-]+@[\w\d\.\-]+$/, :allow_blank => true
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

  def self.find_by_auth_token(token)
    id, token = token.split('$')
    if user = User.find_by_id(id)
      if BCrypt::Password.new(user.auth_token) == token
        return user
      end
    end

  # in case the hash was not set yet
  rescue BCrypt::Errors::InvalidHash
    return nil
  end

  AUTH_TOKEN_SIZE    = 64
  AUTH_TOKEN_SYMBOLS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a

  def new_auth_token!
    token = AUTH_TOKEN_SYMBOLS.shuffle!.slice(0, AUTH_TOKEN_SIZE).join('')
    self.auth_token = BCrypt::Password.create(token).to_s
    self.save
    "#{id}$#{token}"
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
