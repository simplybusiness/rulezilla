steps_for :rule_steps do

  step 'the :field is :value' do |field, value|
    record ||= {}
    field = field.gsub(/\s/,'_').downcase

    value = case value
    when 'blank'
      ""
    when /^less than \d+ digits$/i
      value.scan(/^less than \d+ digits$/i).flatten.first.to_i.times.map{Random.rand(10)}.join
    else
      value
    end

    record[field] = value
    @records = [record]
  end

  step 'the :field is in:' do |field, values|
    @records = []
    field = field.gsub(/\s/,'_').downcase
    values.raw.flatten.each do |telephone_number|
     @records << { field => telephone_number }
   end
  end

  step 'this is a invalid telephone number' do
    @records.each do |record|
      expect(Rulezilla::InvalidNumberRule.apply(record)).to eq true
    end
  end

end
