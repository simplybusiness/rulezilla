@rule_steps
Feature: Invalid Telephone Number Rule

  Scenario: telephone number is blank
    When the "telephone number" is "blank"
    Then this is a invalid telephone number

  Scenario: telephone number is phoney
    When the "telephone number" is in:
      | 00000000000 |
      | 01234567890 |
    Then this is a invalid telephone number

  Scenario: default
    When none of the above
    Then this is not a invalid telephone number
