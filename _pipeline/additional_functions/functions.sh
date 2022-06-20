#!/bin/bash

function build_gem {
  gem_deploy rulezilla.gemspec
}

function check_semaphore {
  check_semaphore_v2_before_proceeding "$SEMAPHORE_V2_PROJECT_ID"
}

function gem_version {
  GEMSPEC=$1

  ruby -e "puts eval(File.read('$GEMSPEC'), TOPLEVEL_BINDING).version.to_s"
}

function slack_notification_on_master {
  local rulezilla_gem_version=$(gem_version "rulezilla.gemspec")
  if [[ "${ENVIRONMENT}" == "live" ]] && [[ "${BRANCH_NAME}" == 'master' ]]; then
    slack_notification $APP_NAME $APP_SLACK_DEPLOYMENT_CHANNEL $NOTICE_COLOR "${SLACK_MESSAGE} v${rulezilla_gem_version}"
  fi
}

function send_final_workflow_status {
  if [[ "${BRANCH_NAME}" == 'master' ]]; then
    bnw_slack_notify_final_workflow_status
  fi
}
