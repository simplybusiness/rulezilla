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

end
