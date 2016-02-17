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


Scenario: If nothing is matched, and no default is defined in the group, it will fall to the next default
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


Scenario Outline: It evaluates the rule against a record
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


Scenario: To get all matching outcomes from a rule
  Given the rule is:
    """
      group :group_1 do
        condition { true }

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
  Then all the matching outcomes are "B, C, D, F"

Scenario: To get all matching outcomes from a rule with root node default result
  Given the rule is:
  """
    group :may_not_injure_human do
      condition { not_injure_human? }

      group :obey_human do
        condition { do_as_human_told? }
        result(true)

        define :protect_its_own_existence do
          condition { in_danger? && not_letting_itself_be_detroyed? }
          result(true)
        end
      end
    end

    default(false)
  """
  When the record has attribute "not_injure_human?" and returns "true"
  When the record has attribute "do_as_human_told?" and returns "true"
  When the record has attribute "in_dangert?" and returns "true"
  When the record has attribute "not_letting_itself_be_detroyed?" and returns "true"
  Then all the matching outcomes are "true, false"

Scenario: To get all matching outcomes from a rule without root node default result
  Given the rule is:
  """
    group :may_not_injure_human do
      condition { not_injure_human? }

      group :obey_human do
        condition { do_as_human_told? }
        result(true)

        define :protect_its_own_existence do
          condition { in_danger? && not_letting_itself_be_detroyed? }
          result(true)
        end
      end
    end
  """
  When the record has attribute "not_injure_human?" and returns "true"
  When the record has attribute "do_as_human_told?" and returns "true"
  When the record has attribute "in_dangert?" and returns "true"
  When the record has attribute "not_letting_itself_be_detroyed?" and returns "true"
  Then all the matching outcomes are "true"

Scenario: Support Module
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


Scenario Outline: Validate the presence of attributes
  Given the rule is:
    """
      validate_attributes_presence :apple, :orange

      default(true)
    """
  When the record has attribute "<attributes>"
  Then "<does or does not>" raise the exception "<exception>"

  Examples:
    | attributes    | does or does not | exception                 |
    | apple         | does             | Missing orange attributes |
    | orange        | does             | Missing apple attributes  |
    | apple, orange | does not         |                           |


Scenario: Rule return nil if no rule is defined
  Given the rule is:
    """
    """
  Then the result is "nil"

Scenario Outline: Trace the path to the result
  Given the rule is:
    """
      group :group_1 do
        condition { group_1_condition }

        group :group_2 do
          condition { group_2_condition }

          define :rule_1 do
            condition { false }
            result('A')
          end

          define :rule_2 do
            condition { rule_2_condition }
            result('B')
          end

          default('C')
        end

        default('D')
      end

      define :rule_3 do
        condition { rule_3_condition }
        result('E')
      end

      default('F')
    """
  When the record has attribute "group_1_condition" and returns "<group_1_condition>"
  And the record has attribute "group_2_condition" and returns "<group_2_condition>"
  And the record has attribute "rule_2_condition" and returns "<rule_2_condition>"
  And the record has attribute "rule_3_condition" and returns "<rule_3_condition>"
  Then the trace is "<trace>"

  Examples:
    | group_1_condition | group_2_condition | rule_2_condition | rule_3_condition | trace                                |
    | true              | true              | true             | true             | root -> group_1 -> group_2 -> rule_2 |
    | true              | false             | true             | true             | root -> group_1                      |
    | false             | true              | true             | true             | root -> rule_3                       |
    | false             | true              | true             | false            | root                                 |

Scenario: Include rule
  Given there is a rule called "CommonRule":
    """
      define :a do
        condition { true }
        result { 'A' }
      end

      define :b do
        condition { false }
        result { 'B' }
      end
    """
  And our rule is:
    """
      include_rule CommonRule
    """
  Then all the outcomes are "A, B"
  And the result is "A"
