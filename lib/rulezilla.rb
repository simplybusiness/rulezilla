require 'rulezilla/node'
require 'rulezilla/tree'
require 'rulezilla/basic_support'
require 'rulezilla/dsl'

module Rulezilla

  def self.set_gherkin_rules_path(path)
    @gherkin_rules_path = path
  end

  def self.gherkin_rules_path
    @gherkin_rules_path
  end

  def self.const_missing(name)
    raise 'Missing Gherkin Rule Path' if gherkin_rules_path.nil?

    matching_file = Dir.glob(File.join(gherkin_rules_path, '**', '*')).detect do |file|
      File.basename(file, ".*") == underscore(name.to_s)
    end

    if matching_file.nil?
      super
    else
      build_rule_from_gherkin(name, matching_file)
    end

  end

  def self.underscore(camel_string)
    camel_string.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def self.build_rule_from_gherkin(klass_name, file)
    require 'gherkin/parser/parser'
    require 'gherkin/formatter/json_formatter'
    require 'stringio'
    require 'json'

    io        = StringIO.new
    formatter = Gherkin::Formatter::JSONFormatter.new(io)
    parser    = Gherkin::Parser::Parser.new(formatter)

    parser.parse(IO.read(file), file, 0)
    formatter.done

    content = JSON.parse(io.string)

    klass = const_set(klass_name, Class.new)

    rules = content.first['elements']

    klass_definition = rules.map do |rule|
      name = rule['name']

      condition_steps = rule['steps'].reject{|step| step['keyword'].strip.downcase == 'then'}
      result_step     = rule['steps'].detect{|step| step['keyword'].strip.downcase == 'then'}

      conditions = condition_steps.map do |step|
        "telephone_number == ''"
      end.join(' && ')

      result = evaluate_result(result_step['name'])

      """
        define \"#{name}\" do
          condition { #{conditions} }
          result(#{result})
        end
      """
    end.join("\n")

    klass.class_eval('include Rulezilla::DSL')
    klass.class_eval(klass_definition)

    klass
  end

  def self.evaluate_result(step_name)
    case step_name
    when /^this is a/i
      true
    when /^this is not a/i
      false
    else
      "\"step_name\""
    end
  end

  private_class_method :underscore
  private_class_method :build_rule_from_gherkin
  private_class_method :evaluate_result
end
