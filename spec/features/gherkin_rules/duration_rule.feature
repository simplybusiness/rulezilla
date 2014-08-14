@rule_steps
Feature: Duration Rule

  Scenario: Maths class
    When the "name of the class" is "Maths"
    Then the duration is "1" minute

  Scenario: Science class
    When the "name of the class" is "Science"
    Then the duration is "10" hours

  Scenario: PE
    When the "name of the class" is "PE"
    Then the duration is "2" days
