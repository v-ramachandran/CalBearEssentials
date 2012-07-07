Feature: The first time I login and/or am asked to register, I should have some pre-populated fields from signing-in with Facebook

  As a student
  So that I can use the Bear Essentials Planner app efficiently
  I want my registration form to be pre-populated on Bear Essentials
  
Scenario: I should see pre-populated fields for First Name, Last Name, E-mail, and empty fields for Major and Start Semester

  When I login with Facebook as a "Unregistered Student"

  Then I should be on the "Registration" page
  And I should see the following form fields: First Name, Last Name, E-mail, Degree, Start Semester, Start Year
  And the following form fields should not be blank: First Name, Last Name, Email
  And the following form fields should be selectable: Degree, Start Semester, Start Year
