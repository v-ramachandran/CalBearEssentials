#When /^I am logged in with Facebook$/ do
#  visit '/auth/facebook'
#end

When /^I logout of BearEssentials$/ do
  visit signout_path
end

When /^I login with Facebook as a "([^"]*)"/ do |user_type|
  step %Q(I am on the home page)
  step %Q(I am a "#{user_type}")
  visit '/auth/facebook'
end

When /^I am logged in .*as a "([^"]*)"/ do |user_type|
  step %Q(I login with Facebook as a "#{user_type}")
end

When /^I am a "([^"]*)"/ do |user_type|
  OmniAuth.config.mock_auth[:facebook] = {
    "provider"  => "facebook",
    "uid"       => '12345',
    "info" => {
      "email" => "john@doe.com",
      "first_name" => "John",
      "last_name"  => "Doe",
      "name"       => "John Doe"
      # any other attributes you want to stub out for testing
    }
  }

  # Only the registered users need to have an entry in the Users Table
  if user_type =~ /Registered (.*)Student/
    deg = Degree.find_by_name($1.strip)
    deg_id = deg.id if deg

    Student.create!(:provider => "facebook",
                    :uid => '12345',
                    :first_name => "John",
                    :last_name => "Doe",
                    :degree_id => deg_id,
                    :email => "john@doe.com")
  end


end
