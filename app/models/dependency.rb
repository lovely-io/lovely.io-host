#
# Represents a link between two package _versions_
#
class Dependency < ActiveRecord::Base
  belongs_to :version
  belongs_to :dependent_version, :foreign_key => :dependency_id, :class_name => 'Version'
end
