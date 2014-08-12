step 'the rule class name is :klass_name' do |klass_name|
  @rule_klass_name = klass_name
end

step 'the rule is:' do |rules|
  @rule_klass = Object.const_set(@rule_klass_name || "DummyRule", Class.new)
  @rule_klass.class_eval('include Rulezilla::DSL')
  @rule_klass.class_eval(rules.to_s)
end

step 'the support module called :support_klass_name has definition:' do |support_name, support_definition|
  @support_name = support_name
  @support = Object.const_set(support_name, Module.new)
  @support.class_eval(support_definition)
end

step 'the record has attribute :method and returns :value' do |method, value|
  value = case value
    when 'true'
      true
    when 'false'
      false
    else
      value
    end
  @record = {method => value}
end

step 'the result is :result' do |result|
  @record ||= {}
  expect(@rule_klass.apply(@record)).to eq result
  step 'clear dummy classes'
end

step 'all the outcomes are :outcomes' do |outcomes|
  outcomes = outcomes.split(',').map{|s| s.strip}
  expect(@rule_klass.results).to match_array outcomes
  step 'clear dummy classes'
end

step 'clear dummy classes' do
  Object.send(:remove_const, (@rule_klass_name || 'DummyRule').to_sym) rescue NameError
  Object.send(:remove_const, "#{(@rule_klass_name || 'DummyRule')}Record".to_sym) rescue NameError
  Object.send(:remove_const, "#{(@support_name || 'DummyRule')}Support".to_sym) rescue NameError
end

