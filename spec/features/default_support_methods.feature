Feature: Default Support methods

Scenario Outline: does_not?
  Given the rule is:
    """
      define :not_sleep do
        condition { does_not?(go_to_bed) }
        result('Tired')
      end

      default('Refreshing')
    """
  When the record has attribute "go_to_bed" and returns "<value>"
  Then the result is "<result>"

  Examples:
    | value | result     |
    | true  | Refreshing |
    | false | Tired      |
    |       | Refreshing |
    | nil   | Refreshing |
