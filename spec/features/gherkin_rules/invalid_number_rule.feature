@rule_steps
Feature: InvalidNumberRule

Scenario: telephone number is blank
  Given the "telephone number" is "blank"
  Then this is a invalid telephone number

Scenario: telephone number too short
  Given the "telephone number" is "less than 10 digits"
  Then this is a invalid telephone number

# Scenario: telephone number is phoney
#   Given telephone number is either:
#     | 00000000000 |
#     | 01234567890 |
#   Then this is a invalid telephone number

# Scenario: default
#   Given non of the above
#   Then this is a valid telephone number
