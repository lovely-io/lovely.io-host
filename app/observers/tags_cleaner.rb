#
# Cleanups empty tags after versions create/update/remove
#
class TagsCleaner < ActiveRecord::Observer
  observe :version

  def after_save(version)
    Tag.cleanup
  end

  def after_delete(version)
    Tag.cleanup
  end
end