module Rulezilla
  class RuleBuilder
    class DefaultCondition; end

    class GherkinToConditionRule
      include Rulezilla::DSL

      define :'this is a "field"' do
        condition { name =~ /^this is\s?a?n? \"(.*)\"$/i }

        result do
          field = name.scan(/^this is\s?a?n? \"(.*)\"$/i).flatten.first
          "#{field}?"
        end
      end

      define :'the "field" is "value"' do
        condition { name =~ /^the \"(.*)\" is \"(.*)\"$/i }

        result do
          field, value = name.scan(/^the \"(.*)\" is \"(.*)\"$/i).flatten
          field = field.gsub(/\s/, '_').downcase

          "#{field} == #{ConditionValueEvaluateRule.apply(value: value)}"
        end
      end

      define :'the "field" is in: {table}' do
        condition { name =~ /^the \"(.*)\" is in:$/i }

        result do
          field = name.scan(/^the \"(.*)\" is in:$/i).flatten.first
          field = field.gsub(/\s/, '_').downcase

          values = rows.map{ |row| "#{ConditionValueEvaluateRule.apply(value: row['cells'].first)}" }.join(', ')

          "[#{values}].include?(#{field})"
        end
      end

      define :'none of the above' do
        condition { name == 'none of the above' }
        result(DefaultCondition)
      end

      default { raise "Condition steps is not recognised: #{name}" }
    end



    class ConditionValueEvaluateRule
      include Rulezilla::DSL

      define :blank do
        condition { value == 'blank'}
        result("''")
      end

      default { "\"#{value}\"" }
    end
  end

end
