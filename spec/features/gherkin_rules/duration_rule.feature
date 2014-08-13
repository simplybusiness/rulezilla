@rule_steps
Feature: Duration Rule

  Scenario: 60 seconds
    When the "number of seconds" is "60"
    Then the duration is "1" minute

  Scenario: 60 seconds
    When the "number of minutes" is "600"
    Then the duration is "10" hours

  Scenario: 48 hours
    When the "number of hours" is "48"
    Then the duration is "2" days
