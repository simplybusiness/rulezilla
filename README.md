[![Semaphore](https://semaphoreapp.com/api/v1/projects/e488365d-9c57-4431-916a-72aea091d1b5/229083/shields_badge.png)](https://semaphoreapp.com/simplybusiness/rulezilla)
[![Code Climate](https://codeclimate.com/repos/53ecc0416956800c1d01f6bf/badges/76b47eaeffc33e312508/gpa.svg)](https://codeclimate.com/repos/53ecc0416956800c1d01f6bf/feed)
[![Gem Version](https://badge.fury.io/rb/rulezilla.svg)](http://badge.fury.io/rb/rulezilla)

rulezilla
=========

This provide a DSL to implement rules for various tasks. In the current version we are still rely user to have a certain level of Ruby knowledge to be able to use this DSL. The ultimate goal is for people without prior Ruby knowledge can change and even write the Rule.


# Installation

    gem 'rulezilla'

## Implementation

### Rules

#### Gherkin (Beta)

rulezilla Gherkin has only very limited support now

First set the path of which rulezilla can load the feature files from:

    Rulezilla.gherkin_rules_path = 'absolute path'

The filename will then converted to the name of the class, e.g. `invalid_number_rule.feature` will generate `Rulezilla::InvalidNumberRule` class

We currently only support a very limited steps, please refer to:

[True / False](spec/features/gherkin_rules/animal_rule.feature)

[Duration](spec/features/gherkin_rules/duration_rule.feature)


#### Ruby

Please refer to the [feature](spec/features/rulezilla_dsl_framwork.feature) for further details

To use rulezilla, please include `Rulezilla::DSL` in your class:

    class RoboticsRule
      include Rulezilla::DSL

      group :may_not_injure_human do
        condition { not_injure_human? }

        group :obey_human do
          condition { do_as_human_told? }

          define :protect_its_own_existence do
            condition { protect_itself? }
            result(true)
          end
        end
      end

      default(false)

    end

### Support Module

The support module will be automatically included if its name is `"#{rule_class_name}Support"`

e.g. if the rule class name is `RoboticsRule`, then the support would be `RoboticsRuleSupport`

    module RoboticsRuleSupport
      def protect_itself?
        in_danger? && not_letting_itself_be_detroyed?
      end
    end

### How to execute the rule

if the entity is:

    {
      not_injure_human?: true,
      do_as_human_told?: true,
      in_danger?:        true,
      not_letting_itself_be_detroyed?: true
    }

#### To get the first matching result

    RoboticsRule.apply(entity) #=> true

#### To get all matching results

    RoboticsRule.all(entity) #=> [true]

#### To get the trace of all node

    RoboticsRule.trace(entity)
    #=> all the nodes instance: [root, may_not_injure_human, obey_human, protect_its_own_existence] in sequence order.

#### To get all results from the Rule

    RoboticsRule.results #=> [true, false]


# Syntax

Please refer to the features for DSL syntax:

[DSL Feature](spec/features/rulezilla_dsl_framwork.feature),

[Default Support Methods Feature](spec/features/default_support_methods.feature)
