# frozen_string_literal: true

step 'the rule class name is :klass_name' do |klass_name|
  @rule_klass_name = klass_name
end

step 'the rule is:' do |rules|
  @rule_klass = Object.const_set(@rule_klass_name || 'DummyRule', Class.new)
  @rule_klass.class_eval('include Rulezilla::DSL', __FILE__, __LINE__)
  @rule_klass.class_eval(rules.to_s)
end

step 'our rule is:' do |rules|
  @rule_klass = Object.const_set('DummyRule', Class.new)
  @rule_klass.class_eval('include Rulezilla::DSL', __FILE__, __LINE__)
  @rule_klass.class_eval(rules.to_s)
end

step 'there is a rule called :rule_name:' do |rule_name, rules|
  send 'the rule class name is :klass_name', rule_name
  @rule_klass = Object.const_set(@rule_klass_name || 'DummyRule', Class.new)
  @rule_klass.class_eval('include Rulezilla::DSL', __FILE__, __LINE__)
  @rule_klass.class_eval(rules.to_s)
end

step 'the support module called :support_klass_name has definition:' do |support_name, support_definition|
  @support_name = support_name
  @support = Object.const_set(support_name, Module.new)
  @support.class_eval(support_definition)
end

step 'the record has attribute :method and returns :value' do |method, value|
  @record ||= {}
  value = case value
          when 'true'
            true
          when 'false'
            false
          when 'nil'
            nil
          else
            value
          end
  @record[method] = value
end

step 'the record has attribute :attributes' do |attributes|
  @record ||= {}
  attributes = attributes.split(',').map(&:strip)
  attributes.each do |key|
    @record[key] = true
  end
end

step 'the result is :result' do |result|
  @record ||= {}

  result = case result
           when 'true'
             true
           when 'false'
             false
           when 'nil'
             nil
           else
             result
           end

  expect(@rule_klass.apply(@record)).to eq result
end

step 'all the outcomes are :outcomes' do |outcomes|
  outcomes = outcomes.split(',').map(&:strip)
  expect(@rule_klass.results).to match_array outcomes
end

step 'all the matching outcomes are :outcomes' do |outcomes|
  outcomes = outcomes.split(',').map(&:strip).map do |o|
    if o == 'true'
      true
    else
      (o == 'false' ? false : o)
    end
  end
  expect(@rule_klass.all(@record)).to match_array outcomes
end

step ':does_or_does_not raise the exception :exception' do |does_or_does_not, _exception|
  if does_or_does_not == 'does'
    expect { @rule_klass.apply @record }.to raise_error do |exception|
      expect(exception.message).to match(/#{exception}/)
    end
  else
    expect { @rule_klass.apply @record }.not_to raise_error
  end
end

step 'the trace is :trace' do |trace|
  trace = trace.split('->').map(&:strip)
  expect(@rule_klass.trace(@record).map(&:name)).to eq trace
end
