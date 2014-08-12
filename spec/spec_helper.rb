require 'rulezilla'
require 'pry'

Dir.glob("spec/features/step_definitions/**/*steps.rb") { |f| load f, true }

RSpec.configure do |config|
  config.after(:each) do
    Object.send(:remove_const, (@rule_klass_name || 'DummyRule').to_sym) rescue NameError
    Object.send(:remove_const, "#{(@rule_klass_name || 'DummyRule')}Record".to_sym) rescue NameError
    Object.send(:remove_const, "#{(@support_name || 'DummyRule')}Support".to_sym) rescue NameError
  end
end
