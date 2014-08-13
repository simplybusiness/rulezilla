require 'gherkin/parser/parser'
require 'gherkin/formatter/json_formatter'
require 'stringio'
require 'json'

module Rulezilla
  class RuleBuilder

    attr_reader :name, :file

    def initialize(name, file)
      @name = name
      @file = file
    end

    def build
      klass_definition = rules.map do |rule|
        rule = RuleDefinition.new(rule)

        """
          define \"#{rule.name}\" do
            condition { #{rule.conditions} }
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

    def rules
      gherkin_json.first['elements']
    end

    def gherkin_json
      @gherkin_json ||= begin
        io        = StringIO.new
        formatter = Gherkin::Formatter::JSONFormatter.new(io)
        parser    = Gherkin::Parser::Parser.new(formatter)

        parser.parse(IO.read(file), file, 0)
        formatter.done

        JSON.parse(io.string)
      end
    end


    class RuleDefinition
      def initialize(gherkin_json)
        @gherkin_json = gherkin_json
      end

      def name
        @gherkin_json['name']
      end

      def conditions
        condition_steps = steps.reject{|step| step['keyword'].strip.downcase == 'then'}
        conditions = condition_steps.map do |step|
          "telephone_number == ''"
        end.join(' && ')
      end

      def result
        evaluate_result(steps.detect{|step| step['keyword'].strip.downcase == 'then'}['name'])
      end

      def evaluate_result(step_name)
        case step_name
        when /^this is a/i
          true
        when /^this is not a/i
          false
        else
          "\"#{step_name}\""
        end

      end

      def steps
        @steps ||= @gherkin_json['steps']
      end

    end
  end
end
