Feature: Display the degree requirements that need to be fulfilled and my current progress with them
 
  As a sincere student
  So that I can plan my remaining classes based on my completed courses
  I want to see the requirements fulfilled towards graduation

Background: Make sure I am on the right page with the right data

  Given I have the following Degrees:
  | name |
  | CS   |
  | EECS |

  And I have the following Courses: 
  | abb	  | name		         | department  | units | weight|
  | CS70  | Discrete Math 	     | cs	       | 4     | 1     |
  | CS160 | UI			         | cs	       | 4     | 1     |
  | CS169 | Software Engineering | cs          | 4     | 1     |

  And I have the following Semesters: 
  | semester | year |
  | Fall     | 2008 |
  | Spring   | 2008 |
  | Spring   | 2009 |
  | Summer   | 2009 |

  And I have the following UnitRequirements:
  | name            | units |
  | Technical Units | 40    |

  And I have the following CourseRequirements:
  | name            | units |
  | Design Course   | 1     |
  
  And "Design Course" satisfy "EECS"
  And "Technical Units" satisfy "EECS"
  And "CS70" fulfills "Technical Units"
  And "CS160" fulfills "Technical Units"
  And "CS169" fulfills "Technical Units"
  And "CS169" fulfills "Design Course"

  And I am logged in as a "Registered EECS Student"
  And I add the following classes to my planner:
  | sid_        | cid_                       | pname_  |
  | Fall 2008   | CS70 Discrete Math         | Record  |  
  | Spring 2008 | CS169 Software Engineering | Record  |  
  | Summer 2009 | CS160 UI                   | Record |

Scenario: Show all the requirements that need to be fulfilled for my degree
 
 When I am on the "Degree Check" page
 Then I should see "The Degree you are pursuing is: EECS"
 And I should see "Technical Units"
 And I should see "Design Course"

Scenario: Show the courses and their units that I have fulfilled under their rquirements
  
  When I am on the "Degree Check" page
  Then I should see "Design Course" before "Software Engineering"
  And I should see "Technical Units" before "UI"
  And I should see "Technical Units" before "Discrete Math"