Feature: Print degree report to show student advisor

  As a dedicated student
  So that I can show my Student and Faculty advisors my degree progress
  I want to print my formal degree report

Background:

  Given I have the following Degrees:
  | name |
  | CS   |
  And I am logged in as a "Registered CS Student"
  And I am on the "My Planner" page
  And I have the following Courses: 
  | abb	  | name		          | department  | units | weight|
  | CS_70  | Discrete_Math        | cs	        | 4     | 1     |
  | CS_160 | UI			          | cs	        | 4     | 1     |
  | CS_169 | Software_Engineering | cs          | 4     | 1     |
  
  And I have the following UnitRequirements:
  | name | units |
  | req1 | 8     |
  
  And I have the following CourseRequirements:
  | name | units |
  | req2 | 2     |
  
  And "req1" satisfy "CS"
  And "req2" satisfy "CS"
  And "CS 70" fulfills "req1"
  And "CS 160" fulfills "req2"
  And "CS 169" fulfills "req2"

  And I have the following Semesters: 
  | semester | year |
  | Fall     | 2008 |
  | Spring   | 2008 |
  | Spring   | 2009 |
  | Summer   | 2009 |
  
  And I am on the "Browse Classes and Plan" page
  And I select the following options for the select fields:  
  | sid_        | cid_      	     | pname_  |
  | Fall 2008   | CS 70 Discrete Math | Record  |  
  And I press "Submit"

  And I select the following options for the select fields:  
  | sid_        | cid_      	             | pname_  |
  | Spring 2008 | CS 169 Software Engineering | Record  |  
  And I press "Submit"

  And I select the following options for the select fields:  
  | sid_        | cid_      	             | pname_  |
  | Summer 2009 | CS 160 UI                   | Record  |
  And I press "Submit"


Scenario: Print degree report

  When I am on the "Degree Check" page
  And I follow the PDF link "Print Report"
  Then I should see "req1 (4/8 units completed)"
  And I should see "CS 70 Discrete Math (4 units)"
  And I should see "Completed - req2 (2/2 courses completed)"
  And I should see "CS 160 UI (4 units)"
  And I should see "CS 169 Software Engineering (4 units)"
  And I should see "req1 (4/8 units completed)" before "CS 70 Discrete Math (4 units)"
  And I should see "CS 70 Discrete Math (4 units)" before "Completed - req2 (2/2 courses completed)"
  And I should see "Completed - req2 (2/2 courses completed)" before "CS 160 UI (4 units)"
  And I should see "CS 160 UI (4 units)" before "CS 169 Software Engineering (4 units)"
