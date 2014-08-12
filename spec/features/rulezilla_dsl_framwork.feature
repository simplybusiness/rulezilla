Feature: Rulezilla DSL

Scenario: To get all outcome from a rule
  Given the rule is:
  """
    group :group_1 do
      condition { false }

      group :group_1_1 do
        condition { true }

        define :rule_1_1_1 do
          condition { false }
          result('A')
        end

        default('B')
      end

      define :rule_1_1 do
        condition { true }
        result('C')
      end

      define :rule_1_2 do
        condition { true }
        result('D')
      end
    end

    define :rule_2 do
      condition { false }
      result('E')
    end

    default('F')
  """
  Then all the outcomes are "A, B, C, D, E, F"

Scenario: Rule is evaluated from top to bottom order
  Given the rule is:
    """
      define :rule_1 do
        condition { true }
        result('Yes')
      end

      define :rule_2 do
        condition { true }
        result('May be')
      end
    """
  Then the result is "Yes"


Scenario: Nesting in Rule DSL
  Given the rule is:
    """
      group :group_1 do
        condition { true }

        define :good do
          condition { true }
          result('Good')
        end
      end
    """
  Then the result is "Good"


Scenario: If nothing is matched in a group, it will fall to default value of the group
  Given the rule is:
    """
      group :group_1 do
        condition { true }

        define :good do
          condition { false }
          result('Good')
        end

        default('It is alright')
      end
    """
  Then the result is "It is alright"


Scenario: If nothing is matched, and no default is define in the group, it will fall to the next default
  Given the rule is:
    """
      group :group_1 do
        condition { true }

        define :good do
          condition { false }
          result('Good')
        end
      end

      default('Everything is awesome')
    """
  Then the result is "Everything is awesome"


Scenario: If nothing is matched, it will continue to evaluate the next group
  Given the rule is:
    """
      group :group_1 do
        condition { true }

        define :good do
          condition { false }
          result('Good')
        end
      end

      group :group_2 do
        condition { true }

        define :bad do
          condition { true }
          result('Bad')
        end
      end
    """
  Then the result is "Bad"


Scenario Outline: It evaluate the rule against a record
  Given the rule is:
    """
      define :fruit do
        condition { fruit }
        result('This is good!')
      end

      define :fruit do
        condition { !fruit }
        result('Oh, too bad')
      end
    """
  When the record has attribute "fruit" and returns "<value>"
  Then the result is "<result>"

  Examples:
    | value | result        |
    | true  | This is good! |
    | false | Oh, too bad   |


Scenario: Support Class
  Given the rule class name is "FruitRule"
  And the support module called "FruitRuleSupport" has definition:
    """
      def is_fruit?
        fruit == true
      end
    """
  And the rule is:
    """
      define :fruit do
        condition { is_fruit? }
        result('This is good!')
      end

      define :fruit do
        condition { !is_fruit? }
        result('Oh, too bad')
      end
    """
  When the record has attribute "fruit" and returns "true"
  Then the result is "This is good!"
