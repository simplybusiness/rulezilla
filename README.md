rulezilla
=========

This is a Rule DSL extract from Call Me Maybe


# Installation

	gem 'rulezilla', git: 'git@github.com:simplybusiness/rulezilla.git'
	

# Rules

Please refer to the feature for more details:
[DSL Feature](spec/features/rulezilla_dsl_framwork.feature)


Here is the syntax for a rule:

```ruby
class SomeRule
  include Rulezilla::DSL

  group :group_1 do
    condition do
      # a condition that this group will apply
    end

    define :rule_1 do
      condition do
        # a condition that this rule will apply
      end

      result do
        # what this rule will return if the condition matches
      end
    end

    default do
      # what this group will return if none of the rules it contains match
    end
  end

  define :rule_2 do
    ...
  end

  default do
    # what the return value will be if none of the groups or rules match
  end
end
```

A rule is meant to be applied on a given record, e.g.

```ruby
SomeRule.apply(record) # => returns one of the results defined in the rule
```

The record can be accessed directly in `condition`, `result` and `default` blocks. A record can be an instance of any object, as long as the rules applied to it are calling the correct methods.

There is a method to return all possible results for a rule, regardless of whether conditions matched or not. Note that this method does not return `default` results.

```ruby
SomeRule.results # => returns all the results defined in the rule
```

## Nesting

Grouping provies the ability to group conditions and build a hierarchy of rules.

### Example 1
This will return `foo` because both the condition for `rule_1` and the condition for its parent `group_1` match:

```ruby
class RULE1
  include Rulezilla::DSL
  group 'group_1' do
    condition { true }

    define 'rule_1' do
      condition { true }
      result    { 'foo' }
    end
  end
end

RULE1.apply # => "foo"
RULE1.results # => ["foo"]
```

### Example 2
This will return `bar` because the condition for `group_1` matches, but the condition for `rule_1` does not, which triggers the default:

```ruby
class RULE2
  include Rulezilla::DSL
  group 'group_1' do
    condition { true }

    define 'rule_1' do
      condition { false }
      result    { 'foo' }
    end

    default 'bar'
  end
end

RULE2.apply # => "bar"
RULE2.results # => ["foo"]
```

### Example 3
This will return `boop` because `group_1` does not match, but `rule_2` does:

```ruby
class RULE3
  include Rulezilla::DSL
  group 'group_1' do
    condition { false }

    define 'rule_1' do
      condition { false }
      result    { 'foo' }
    end

    default 'bar'
  end

  define 'rule_2' do
    condition { true }
    result    { 'boop' }
  end
end

RULE3.apply # => "boop"
RULE3.results # => ["boop", "foo"]
```

Note that if the condition for `group_1` had been `true`, the result would have been `bar`, as the result depends on the *first* condition that matches and `group_1` is defined before `rule_2`.


## Supporting methods

If you need extra methods which the original instance does not provide, you can create a new module that matches the name of the Rule. All the methods in the supporting module is accessible inside the rule.

For example:

    # app/rules/support/foobar_rule_support.rb
    module FoobarRuleSupport
      def apple
      end
    end

    # app/rules/foobar_rule.rb
    class FoobarRule
      include Rulezilla::DSL

      default { apple }
    end

    FoobarRule.apply(fruits)

If the method `apple` is not a standard method in `fruits`, it will append the support method to be used in the Rule, and it will also support all the methods in `fruits`.
