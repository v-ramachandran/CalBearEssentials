require "pdf/inspector"

Then /I should see "(.*)" before "(.*)"$/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  pageString = page.text
  pos1 = pageString.index(e1)
  pos2 = pageString.index(e2)
  assert pos1 < pos2, "condition failure"
end

When /I select the following classes:/ do |table|

end

When /^I follow the PDF link "([^"]+)"$/ do |label|
  click_link(label)
  page.response_headers['Content-Type'].should == "application/pdf; charset=utf-8"
  pdf = PDF::Inspector::Text.analyze(page.source).strings
  page.driver.response.instance_variable_set('@body', pdf)
end

Given /^"([^"]*)" satisfy "([^"]*)"$/ do |arg1, arg2|
  req=Requirement.find_by_name(arg1)
  deg=Degree.find_by_name(arg2)
  Satisfied.create! do |s|
    s.requirement_id = req.id
    s.degree_id = deg.id
  end
end

Given /^"([^"]*)" fulfills "([^"]*)"$/ do |arg1, arg2|
  req=Requirement.find_by_name(arg2)
  course=Course.find_by_abb(arg1.gsub(" ","_"))
  Required.create! do |s|
    s.requirement_id = req.id
    s.course_id = course.id
  end
end

When /^I add the following classes to my planner:/ do |table|
  step %Q{I am on the "Browse Classes and Plan" page}

  table.map_headers!{ |h| h.strip.downcase.gsub(/\s/, '_')}

  table.hashes.each do |fields|
    fields.keys.each do |f_key|
      step %Q{I select "#{fields[f_key]}" from "#{f_key}"}
    end
    step %Q{I press "Submit"}
  end
end
