Feature: Logout from BearEssentials

  As a motivated student
  So that I can plan my academic time at Berkeley
  I want to be able to logout of BearEssentials

Scenario: Successfully logout from BearEssentials as a Registered User

  When I am logged in as a "Registered Student"
  Then I should be on the "My Planner" page
  And I should see "Logout" 

  When I follow "Logout"
  Then I should be on the home page
  And I should see "signed out"

Scenario: Successfully logout from BearEssentials as an Unregistered User
  When I am logged in with Facebook as a "Unregistered Student"
  Then I should be on the "Registration" page
  And I should see "Logout" 

  When I follow "Logout"
  Then I should be on the home page
  And I should see "signed out"

  When I go to the "My Planner" page
  Then I should be on the home page
  And I should see "Please log in before continuing"