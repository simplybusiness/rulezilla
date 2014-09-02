require 'rulezilla/node'
require 'rulezilla/tree'
require 'rulezilla/basic_support'
require 'rulezilla/dsl'
require 'rulezilla/rule_builder'

module Rulezilla
  extend self

  attr_accessor :gherkin_rules_path

  def const_missing(name)
    raise 'Missing Gherkin Rule Path' if gherkin_rules_path.nil?

    matching_file = Dir.glob(File.join(gherkin_rules_path, '**', '*')).detect do |file|
      File.basename(file, ".*") == underscore(name.to_s)
    end

    if matching_file.nil?
      super
    else
      Rulezilla::RuleBuilder.from_file(name, matching_file).build
    end
  end

  private
  def underscore(camel_string)
    camel_string.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

end
