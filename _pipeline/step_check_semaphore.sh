#!/bin/bash
source "/opt/sb/sb-pipeline.sh"
set -e

# -----------------------------------------------------
# Settings
# -----------------------------------------------------
source "_pipeline/config.sh"

# Check the Semaphore build before we make any code live
check_semaphore_v2_before_proceeding "$SEMAPHORE_V2_PROJECT_ID"
