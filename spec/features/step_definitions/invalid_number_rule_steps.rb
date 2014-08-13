steps_for :rule_steps do

  step 'the :field is :value' do |field, value|
    @record ||= {}
    field = field.gsub(/\s/,'_').downcase

    value = case value
    when 'blank'
      ""
    when /^less than \d+ digits$/i
      value.match(/^less than \d+ digits$/i).to_a.last.to_i.times.map{Random.rand(10)}.join
    else
      value
    end

    @record[field] = value
  end

  step 'this is a invalid telephone number' do
    expect(Rulezilla::InvalidNumberRule.apply(@record)).to eq true
  end

end
