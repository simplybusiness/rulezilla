module Rulezilla
  module BasicSupport

    def does_not?(value)
      value == false
    end

    alias_method :is_not?, :does_not?

  end
end
