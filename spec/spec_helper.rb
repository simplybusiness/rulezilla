# frozen_string_literal: true

require 'rulezilla'
require 'pry'

Dir.glob('spec/features/step_definitions/**/*steps.rb') { |f| load f, true }

RSpec.configure do |config|
  config.after do
    begin
      Object.send(:remove_const, :DummyRule)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, :DummyRuleRecord)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, :DummyRuleSupport)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, @rule_klass_name.to_sym)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, :"#{@rule_klass_name}Record")
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, :"#{@support_name}Support")
    rescue StandardError
      NameError
    end
  end
end
