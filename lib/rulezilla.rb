require 'rulezilla/node'
require 'rulezilla/tree'
require 'rulezilla/basic_support'
require 'rulezilla/dsl'
require 'rulezilla/rule_builder'

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
      Rulezilla::RuleBuilder.new(name, matching_file).build
    end
  end

  def self.underscore(camel_string)
    camel_string.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  private_class_method :underscore
end
