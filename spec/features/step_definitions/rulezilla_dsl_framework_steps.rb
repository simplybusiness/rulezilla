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
    when 'nil'
      nil
    else
      value
    end
  @record = {method => value}
end

step 'the record has attribute :attributes' do |attributes|
  attributes = attributes.split(',').map{|s| s.strip}
  @record = {}
  attributes.each do |key|
    @record[key] = true
  end
end

step 'the result is :result' do |result|
  @record ||= {}

  result = result == 'nil' ? nil : result

  expect(@rule_klass.apply(@record)).to eq result
end

step 'all the outcomes are :outcomes' do |outcomes|
  outcomes = outcomes.split(',').map{|s| s.strip}
  expect(@rule_klass.results).to match_array outcomes
end

step ':does_or_does_not not raise the exception :exception' do |does_or_does_not, exception|
  if does_or_does_not == 'does'
    expect{ @rule_klass.apply @record }.to raise_error do |exception|
      expect(exception.message).to match /#{exception}/
    end
  else
    expect{ @rule_klass.apply @record }.not_to raise_error
  end
end
