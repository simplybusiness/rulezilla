module Rulezilla
  class RuleBuilder
    class GherkinToResultRule
      include Rulezilla::DSL

      define :start_with_this_is_a do
        condition { name =~ /^this is a/i }
        result(true)
      end

      define :start_with_this_is_not_a do
        condition { name =~ /^this is not a/i }
        result(false)
      end

      default { "\"#{name}\"" }

    end
  end
end
