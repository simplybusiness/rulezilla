[![Build Status](https://semaphoreci.com/api/v1/projects/e488365d-9c57-4431-916a-72aea091d1b5/229083/shields_badge.svg)](https://semaphoreci.com/simplybusiness/rulezilla)
[![Code Climate](https://codeclimate.com/repos/53ecc0416956800c1d01f6bf/badges/76b47eaeffc33e312508/gpa.svg)](https://codeclimate.com/repos/53ecc0416956800c1d01f6bf/feed)
[![Gem Version](https://badge.fury.io/rb/rulezilla.svg)](http://badge.fury.io/rb/rulezilla)

rulezilla
=========

This provides a DSL to implement rules for various tasks. In the current version we are still relying on user to have a certain level of Ruby knowledge
in order to be able to use this DSL. The ultimate goal is for people without prior Ruby knowledge to be able to change and even write the Rule.


# Installation

## Using `Gemfile`

Add the following line to your `Gemfile`:

    gem 'rulezilla'

Then run:

    bundle install

## Without `Gemfile`

On your command line run the following:

    gem install 'rulezilla'

## Usage

### Rules

Rules can be defined either using `Gherkin` or pure Ruby. In either case, rules are classes that include the `Rulezilla::DSL`.

#### Gherkin (Beta)

> *Note:* Currently, rulezilla Gherkin has only very limited support.

Rules are defined inside `.feature` files which should be organized under a specific directory. In order to be able to use these rules, you need to first
set the path that rulezilla can use in order to load them.

    Rulezilla.gherkin_rules_path = 'absolute path to folder holding your feature files'

Rulezilla will load all the feature files and for each one will create a rule class. The filename will be used to build the name of the rule class. For example,
the file with name `invalid_number_rule.feature` will generate rule class `Rulezilla::InvalidNumberRule`.

We currently support a very limited type of steps. Please refer to:

[True / False](spec/features/gherkin_rules/animal_rule.feature)

[Duration](spec/features/gherkin_rules/duration_rule.feature)

#### Ruby

You can use plain Ruby to define the rule classes. But you will need to include the `Rulezilla::DSL` module. That will give you access to the DSL used to define rules.

Here is an example:

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

Please refer to the [feature](spec/features/rulezilla_dsl_framework.feature) for further details of the DSL.

### Support Module

The support module will be automatically included if its name is `"#{rule_class_name}Support"`

e.g. if the rule class name is `RoboticsRule`, then the support would be `RoboticsRuleSupport`

    module RoboticsRuleSupport
      def protect_itself?
        in_danger? && not_letting_itself_be_detroyed?
      end
    end

### How to execute the rule

If the entity is:

    entity = {
      not_injure_human?:               true,
      do_as_human_told?:               true,
      in_danger?:                      true,
      not_letting_itself_be_detroyed?: true
    }

#### To get the first matching result output

    RoboticsRule.apply(entity) #=> true

#### To get all matching result outputs

    RoboticsRule.all(entity) #=> [true, false]
    
Note that `false` is the result outcome coming out from `default(false)` on top level, which is also called `root node`. The `root` node does not have any condition and hence
it is considered to be matching. This means, by consequence, that its result (`default(false)`) is included in the list of matching result outputs which `#all(entity)` above
returns.

#### To get the trace of all nodes

    RoboticsRule.trace(entity)
    #=> all the nodes instance: [root, may_not_injure_human, obey_human, protect_its_own_existence] in sequence order.

#### To get all results from the Rule

    RoboticsRule.results #=> [true, false]


### Syntax

Please refer to the features for DSL syntax:

[DSL Feature](spec/features/rulezilla_dsl_framework.feature),

[Default Support Methods Feature](spec/features/default_support_methods.feature)
