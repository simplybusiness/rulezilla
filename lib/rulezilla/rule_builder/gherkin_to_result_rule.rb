module Rulezilla
  class RuleBuilder
    class GherkinToResultRule
      include Rulezilla::DSL

      group :this_is_a do
        condition { name =~ /^this is(\snot)? an?/i }

        define :start_with_this_is_a do
          condition { name =~ /^this is an? #{step_keyword}$/i }
          result(true)
        end

        define :start_with_this_is_not_a do
          condition { name =~ /^this is not an? #{step_keyword}$/i }
          result(false)
        end

        default do
          wrong_keyword = name.scan(/^this is not an? (.*)$/i).flatten.first
          raise "Unrecognisable keyword: #{wrong_keyword}"
        end
      end

      default { "\"#{name}\"" }

    end
  end
end
