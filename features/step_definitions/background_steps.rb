When /^I have the following (.*)s:$/ do | obj, table |
  table.hashes.each do |entry|
    eval(obj).create!(entry)
  end
end
