require 'rulezilla'
require 'pry'

Dir.glob("spec/features/step_definitions/**/*steps.rb") { |f| load f, true }
