Feature: Delete classes from My Planner
 
  As a motivated student
  So that I can modify the classes on my planner according to my plan
  I want to delete courses from my planner

Background: 

  Given I have the following Courses: 
  | abb	  | name		 | department  | units | weight|
  | CS70  | Discrete Math 	 | cs	       | 4     | 1     |
  | CS160 | UI			 | cs	       | 4     | 1     |
 
  And I have the following Semesters: 
  | semester | year |
  | Fall     | 2008 |
  | Spring   | 2009 |
  
  And I am logged in as a "Registered Student"
  And I am on the "Browse Classes and Plan" page

Scenario: I successfully delete a class from Future Planner

  When I select the following options for the select fields:  
  | sid_        | cid_      	     | pname_  |
  | Fall 2008   | CS70 Discrete Math | Planner |
  And I press "Submit"
  
  Then I should see /CS70 \- Discrete Math/
  When I follow "Delete"
  Then I should be on the "Browse Classes and Plan" page
  And I should see "CS70 has been deleted"
  But I should not see "CS70 - Discrete Math"

Scenario: I successfully delete a class from Past Planner

  When I select the following options for the select fields:  
  | sid_        | cid_     | pname_  |
  | Spring 2009 | CS160 UI | Record  |
  And I press "Submit"

  Then I should see /CS160 \- UI[\s\n]*Delete/

  When I follow "Delete"
  Then I should be on the "Browse Classes and Plan" page
  And I should see "CS160 has been deleted"
  But I should not see "CS160 - UI"