#
# Making BCrypt to use the minimal cost so that the specs run faster
#
require 'bcrypt'

module BCrypt
  class Engine
    class << self
      alias :_generate_salt :generate_salt

      def generate_salt(cost = MIN_COST)
        _generate_salt(MIN_COST)
      end
    end
  end
end