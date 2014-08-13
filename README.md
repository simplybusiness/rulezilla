rulezilla
=========

This provide a DSL to implement rules for various tasks. In the current version we are still rely user to have a certain level of Ruby knowledge to be able to use this DSL. The ultimate goal is for people without prior Ruby knowledge can change and even write the Rule.


# Installation

    gem 'rulezilla', git: 'git@github.com:simplybusiness/rulezilla.git'

## Implementation

### Rules

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

#### To get the result

    RoboticsRule.apply(entity) #=> true

#### To get the trace of all node

    RoboticsRule.apply(entity)
    #=> all the nodes instance: [root, may_not_injure_human, obey_human, protect_its_own_existence] in sequence order.



# Syntax

Please refer to the features for DSL syntax:

[DSL Feature](spec/features/rulezilla_dsl_framwork.feature),

[Default Support Methods Feature](spec/features/default_support_methods.feature)
