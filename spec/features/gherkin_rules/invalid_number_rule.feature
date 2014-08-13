@rule_steps
Feature: InvalidNumberRule

  Scenario: telephone number is blank
    When the "telephone number" is "blank"
    Then this is a invalid telephone number

  Scenario: telephone number too short
    When the "telephone number" is "less than 10 digits"
    Then this is a invalid telephone number

  Scenario: telephone number is phoney
    When the "telephone number" is in:
      | 00000000000 |
      | 01234567890 |
    Then this is a invalid telephone number

  Scenario: default
    When none of the above
    Then this is not a invalid telephone number
