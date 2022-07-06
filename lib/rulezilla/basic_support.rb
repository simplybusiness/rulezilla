# frozen_string_literal: true

module Rulezilla
  module BasicSupport
    def does_not?(value)
      value == false
    end

    alias is_not? does_not?
  end
end
