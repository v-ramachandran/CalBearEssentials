Feature: Add classes to My Planner
 
  As a motivated student
  So that I can store all my taken and desired courses
  I want to add courses to My Planner

Background: 

  Given I have the following Courses: 
  | abb	  | name		 | department  | units | weight|
  | CS70  | Discrete Math 	 | cs	       | 4     | 1     |
  | CS160 | UI			 | cs	       | 4     | 1     |
  | CS169 | Software Engineering | cs          | 4     | 1     |

  And I have the following Semesters: 
  | semester | year |
  | Fall     | 2008 |
  | Spring   | 2008 |
  | Spring   | 2009 |
  | Summer   | 2009 |  
  
  And I am logged in as a "Registered Student"
  And I am on the "Browse Classes and Plan" page


Scenario: I successfully add a class to a Future Planner

  When I select the following options for the select fields:  
  | sid_        | cid_      	     | pname_  |
  | Fall 2008   | CS70 Discrete Math | Planner |
  
  And I press "Submit"
  Then I should be on the "Browse Classes and Plan" page
  And I should see "Fall 2008"
  And I should see "CS70 - Discrete Math"
  And I should see "Fall 2008" before "CS70 - Discrete Math"

Scenario: I successfully add a class to a Past Planner

  When I select the following options for the select fields:  
  | sid_        | cid_      	     | pname_  |
  | Fall 2008   | CS70 Discrete Math | Record  |
  
  And I press "Submit"
  Then I should be on the "Browse Classes and Plan" page
  And I should see "Fall 2008"
  And I should see "CS70 - Discrete Math" 
  And I should see "Fall 2008" before "CS70 - Discrete Math"

Scenario: I add multiple classes across different semesters and see them displayed chronologically

  When I select the following options for the select fields:  
  | sid_        | cid_      	     | pname_  |
  | Fall 2008   | CS70 Discrete Math | Record  |  
  And I press "Submit"

  And I select the following options for the select fields:  
  | sid_        | cid_      	             | pname_  |
  | Spring 2008 | CS169 Software Engineering | Record  |  
  And I press "Submit"

  And I select the following options for the select fields:  
  | sid_        | cid_      	             | pname_  |
  | Summer 2009 | CS160 UI                   | Record  |
  And I press "Submit"

  Then I should be on the "Browse Classes and Plan" page

  And I should see "Fall 2008" before "Summer 2009" within the planner section
  And I should see "Spring 2008" before "Fall 2008" within the planner section

  And I should see "Fall 2008" before "CS70 - Discrete Math" within the planner section
  And I should see "CS70 - Discrete Math" before "Summer 2009" within the planner section
  And I should see "CS169 - Software Engineering" before "Fall 2008" within the planner section
  
Scenario: I add a class with a blank planner paramater and not see it added

  When I select the following options for the select fields:  
  | sid_        | cid_      	     |
  | Fall 2008   | CS70 Discrete Math |  
  And I press "Submit"
  
  Then I should be on the "My Planner" page
  And I should not see "CS70 - Discrete Math"

Scenario: I add a class with a blank course paramater and not see it added

  When I select the following options for the select fields:  
  | sid_        | pname_  |
  | Fall 2008   | Record  |  
  And I press "Submit"
  
  Then I should be on the "My Planner" page
  And I should not see "Fall 2008"
  
Scenario: I add a class with a blank semester paramater and not see it added

  When I select the following options for the select fields:  
  | cid_     	       | pname_  |
  | CS70 Discrete Math | Record  |  
  And I press "Submit"
  
  Then I should be on the "My Planner" page
  And I should not see "CS70 - Discrete Math"
