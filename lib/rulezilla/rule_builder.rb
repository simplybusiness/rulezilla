require 'gherkin/parser/parser'
require 'gherkin/formatter/json_formatter'
require 'stringio'
require 'json'
require 'rulezilla/rule_builder/gherkin_to_result_rule'
require 'rulezilla/rule_builder/gherkin_to_condition_rule'

module Rulezilla
  class RuleBuilder

    def self.from_file(name, file)
      new(name, IO.read(file))
    end

    attr_reader :name, :content

    def initialize(name, content)
      @name    = name
      @content = content
    end

    def build
      klass_definition = rules.map do |rule|
        rule = RuleDefinition.new(rule, step_keyword)

        condition_definition = rule.conditions.empty? ? "" : "condition { #{rule.conditions} }"

        """
          define \"#{rule.name}\" do
            #{condition_definition}
            result(#{rule.result})
          end
        """
      end.join("\n")

      klass = Rulezilla.const_set(name, Class.new)

      klass.class_eval('include Rulezilla::DSL')
      klass.class_eval(klass_definition)

      klass
    end


    private

    def step_keyword
      gherkin_json.first['name'].gsub(/\s?rule/i, '')
    end

    def rules
      gherkin_json.first['elements']
    end

    def gherkin_json
      @gherkin_json ||= begin
        io        = StringIO.new
        formatter = Gherkin::Formatter::JSONFormatter.new(io)
        parser    = Gherkin::Parser::Parser.new(formatter)

        parser.parse(content, content, 0)
        formatter.done

        JSON.parse(io.string)
      end
    end


    class RuleDefinition
      def initialize(gherkin_json, step_keyword)
        @gherkin_json = gherkin_json
        @step_keyword = step_keyword
      end

      def name
        @gherkin_json['name']
      end

      def conditions
        condition_steps = steps.reject{|step| step['keyword'].strip.downcase == 'then'}
        conditions = condition_steps.map do |step|
          ::Rulezilla::RuleBuilder::GherkinToConditionRule.apply(record(step))
        end.reject{|condition| condition == Rulezilla::RuleBuilder::DefaultCondition}.join(' && ')
      end

      def result
        ::Rulezilla::RuleBuilder::GherkinToResultRule.apply record(steps.detect{|step| step['keyword'].strip.downcase == 'then'})
      end

      private

      def steps
        @steps ||= @gherkin_json['steps']
      end

      def record(step)
        step.merge(step_keyword: @step_keyword)
      end
    end
  end
end
