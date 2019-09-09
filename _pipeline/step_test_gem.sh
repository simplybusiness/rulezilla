#!/bin/bash
source "/opt/sb/sb-pipeline.sh"
set -e

bundle install
bundle exec rspec
