Feature: Rulezilla Gherkin DSL

  Scenario: Condition: something is something
    Given the gherkin is:
      """
        Feature: Awesomeness Rule

        Scenario: Robocop
          When the "target" is "Robocop"
          Then the awesomeness is "very awesome"
      """
    When the record has attribute "target" and returns "Robocop"
    Then the result is "very awesome"


  Scenario: Multiple Condition: something is something
    Given the gherkin is:
      """
        Feature: Winner Rule

        Scenario: Robocop vs Ironman
          When the "target" is "Robocop"
          And the "opponent" is "Ironman"
          Then the winner is "Ironman"
      """
    When the record has attribute "target" and returns "Robocop"
    And the record has attribute "opponent" and returns "Ironman"
    Then the result is "Ironman"


  Scenario: Default
    Given the gherkin is:
      """
        Feature: Winner Rule

        Scenario: Default
          When none of the above
          Then the winner is "Ironman"
      """
    Then the result is "Ironman"


  Scenario: 'The :keyword is :value', Keyword mismatch
    Given the incorrect gherkin is:
      """
        Feature: Winner Rule

        Scenario: Default
          When none of the above
          Then the loser is "Hello kitty"
      """
    Then it raises exception "Unrecognisable step: the loser is 'Hello kitty'"


  Scenario: True value
    Given the gherkin is:
      """
        Feature: Dummy Rule

        Scenario: Dummy
          When the "name" is "007"
          Then this is a dummy
      """
    When the record has attribute "name" and returns "007"
    Then the result is "true"


  Scenario: False value
    Given the gherkin is:
      """
        Feature: Dummy Rule

        Scenario: Not Dummy
          When the "name" is "Tom"
          Then this is not a dummy
      """
    When the record has attribute "name" and returns "Tom"
    Then the result is "false"


  Scenario: 'This is( not) a :keyword', Keyword mismatch
    Given the incorrect gherkin is:
      """
        Feature: Winner Rule

        Scenario: Not Dummy
          When the "name" is "Tom"
          Then this is not a cat
      """
    Then it raises exception "Unrecognisable step: this is not a 'cat'"
