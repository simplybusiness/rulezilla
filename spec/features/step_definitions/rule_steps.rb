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

  step 'this is an animal' do
    @records.each do |record|
      expect(Rulezilla::AnimalRule.apply(record)).to eq true
    end
  end

  step 'this is not an animal' do
    @records.each do |record|
      expect(Rulezilla::AnimalRule.apply(record)).to eq false
    end
  end

  step 'none of the above' do
    @records = [{telephone_number: '09827364755'}]
  end

  step 'the duration is :day days' do |day|
    send 'the duration is :second seconds', day.to_i * 86400
  end

  step 'the duration is :hour hours' do |hour|
    send 'the duration is :second seconds', hour.to_i * 3600
  end

  step 'the duration is :minute minute' do |minute|
    send 'the duration is :second seconds', minute.to_i * 1800
  end

  step 'the duration is :second seconds' do |second|
    expect(Rulezilla::DurationRule.apply(@records.first)).to eq second.to_i
  end

end
