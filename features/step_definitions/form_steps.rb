When /^I .*see the following form fields: (.*)/ do |fields|
  fields.to_s.split(",").each do |field|
    step %Q{I should see "#{field.strip}"}
  end
end

When /^the following form fields should (not )?be blank: (.*)/ do |not_blank, fields|
  fields.to_s.split(",").each do |field|
    field = find_field(field.strip.downcase.gsub(/\s/, '_'))
    field_value = (field.tag_name == 'textarea') ? field.text : field.value

    if not_blank
      if field_value.respond_to? :should_not
        field_value.should_not be_nil
      else
        assert_match(/.+/, field_value)
      end
    else
      if field_value.respond_to? :should
        field_value.should be_nil
      else
        assert_match(//, field_value)
      end
    end

  end
end

When /^the following form fields should be selectable: (.*)/ do |fields|
  fields.to_s.split(",").each do |field|
    field = field.strip.downcase.gsub(/\s/, '_')
    if page.respond_to? :should
      page.should have_select(field)
    else
      assert page.has_select?(field)
    end
  end
end

When /^I fill in the fields as such:/ do |f_table|

  f_table.map_headers!('E-mail' => :email){ |h| h.strip.downcase.gsub(/\s/, '_')}

  f_table.hashes.each do |user_fields|
    user_fields.keys.each do |f_key|
      step %Q(I fill in "#{f_key}" with "#{user_fields[f_key]}")
    end
  end

end

When /^I select the following options for the select fields:/ do |f_table|

  f_table.map_headers!{ |h| h.strip.downcase.gsub(/\s/, '_')}

  f_table.hashes.each do |fields|
    fields.keys.each do |f_key|
      step %Q(I select "#{fields[f_key]}" from "#{f_key}")
    end
  end
end
