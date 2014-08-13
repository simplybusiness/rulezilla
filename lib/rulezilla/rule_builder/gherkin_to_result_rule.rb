module Rulezilla
  class RuleBuilder
    class GherkinToResultRule
      include Rulezilla::DSL

      define :duration_is do
        condition { name =~ /^the #{step_keyword} is \"(\d+)\" (.*)$/i }
        result do
          quantity, unit = name.scan(/^the #{step_keyword} is \"(\d+)\" (days?|hours?|minutes?|seconds?)$/i).flatten

          multiplier = case unit
          when /day/
            86400
          when /hour/
            3600
          when /minute/
            1800
          when /second/
            1
          end

          quantity.to_i * multiplier
        end
      end

      define :start_with_this_is_a do
        condition { name =~ /^this is an? #{step_keyword}$/i }
        result(true)
      end

      define :start_with_this_is_not_a do
        condition { name =~ /^this is not an? #{step_keyword}$/i }
        result(false)
      end

      default { raise "Unrecognisable step: #{name}" }

    end
  end
end
