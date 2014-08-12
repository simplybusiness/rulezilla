Feature: Default Support methods

Scenario Outline: does_not?
  Given the rule is:
    """
      define :fruit do
        condition { does_not?(fruit) }
        result('Not fruit')
      end

      default('Is fruit')
    """
  When the record has attribute "fruit" and returns "<value>"
  Then the result is "<result>"

  Examples:
    | value | result    |
    | true  | Is fruit  |
    | false | Not fruit |
    |       | Is fruit  |
