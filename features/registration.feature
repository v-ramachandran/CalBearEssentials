Feature: The first time I login, I should register with my relevant student details

  As a student
  So that I can use the Bear Essentials Planner app efficiently
  I want to register as a student on Bear Essentials

Background:

  Given I have the following Degrees: 
  | name |
  | EECS |
  |  CS  |

  And I have the following Semesters: 
  | semester | year |
  | Fall     | 2008 |
  | Spring   | 2008 |  

  And I login with Facebook as a "Unregistered Student":
  And I should be on the "Registration" page

Scenario: I should be able to provide my relevant details

  When I fill in the fields as such: 
  | Last Name | First Name | E-mail           |
  | Bitdiddle | Ben        | ben@berkeley.edu |

  And I select the following options for the select fields:  
  | Degree | Start Semester | Start Year |
  | EECS   | Fall           | 2008       |

  And I press "Register"
  Then I should be on the "My Planner" page
  And I should see "Thanks Ben, you have been successfully registered"

Scenario: If I leave a field blank I should not pass

  When I fill in the fields as such: 
  | Last Name | First Name | E-mail           |
  | Bitdiddle |            | ben@berkeley.edu |

  And I select the following options for the select fields:  
  | Degree | Start Semester | Start Year |
  | EECS   | Fall           | 2008       |

  And I press "Register"
  Then I should be on the "Registration" page
  And I should see "Please make sure none of the fields are blank and/or that your email-address is valid "

Scenario: If I input an invalid email I should not pass

  When I fill in the fields as such: 
  | Last Name | First Name | E-mail       |
  | Bitdiddle | Ben        | ben@berkeley |

  And I select the following options for the select fields:  
  | Degree | Start Semester | Start Year |
  | EECS   | Fall           | 2008       |

  And I press "Register"
  Then I should be on the "Registration" page
  And I should see "Please make sure none of the fields are blank and/or that your email-address is valid "

