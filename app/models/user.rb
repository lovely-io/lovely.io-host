class User < ActiveRecord::Base
  attr_accessible :email, :name

  validates_presence_of :provider, :uid
  validate :provider_and_uid_uniqueness

private

  def provider_and_uid_uniqueness
    if self.class.find_by_provider_and_uid(provider, uid)
      self.errors.add(:uid, "is already taken for this provider")
    end
  end
end
