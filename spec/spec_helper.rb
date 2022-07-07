# frozen_string_literal: true

require 'rulezilla'
require 'pry'

Dir.glob('spec/features/step_definitions/**/*steps.rb') { |f| load f, true }

RSpec.configure do |config|
  config.after(:each) do
    begin
      Object.send(:remove_const, 'DummyRule'.to_sym)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, 'DummyRuleRecord'.to_sym)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, 'DummyRuleSupport'.to_sym)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, @rule_klass_name.to_sym)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, "#{@rule_klass_name}Record".to_sym)
    rescue StandardError
      NameError
    end
    begin
      Object.send(:remove_const, "#{@support_name}Support".to_sym)
    rescue StandardError
      NameError
    end
  end
end
