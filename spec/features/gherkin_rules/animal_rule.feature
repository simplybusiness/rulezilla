@rule_steps
Feature: AnimalRule

  Scenario: entity is a cat
    When the "entity" is "cat"
    Then this is an animal

  Scenario: telephone number is dog or bird
    When the "entity" is in:
      | dog  |
      | bird |
    Then this is an animal

  Scenario: default
    When none of the above
    Then this is not an animal
