module Rulezilla
  class RuleBuilder
    class GherkinToResultRule
      include Rulezilla::DSL

      group :this_is_a do
        condition { name =~ /^this is(\snot)? a/i }

        define :start_with_this_is_a do
          condition { name =~ /^this is a #{step_keyword}$/i }
          result(true)
        end

        define :start_with_this_is_not_a do
          condition { name =~ /^this is not a #{step_keyword}$/i }
          result(false)
        end

        default do
          wrong_keyword = name.scan(/^this is not a (.*)$/i).flatten.first
          raise "Unrecognisable keyword: #{wrong_keyword}"
        end
      end

      default { "\"#{name}\"" }

    end
  end
end
